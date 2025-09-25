import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Performance monitoring utilities
class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();

  final Map<String, Stopwatch> _timers = {};
  final Map<String, List<Duration>> _measurements = {};

  /// Start timing an operation
  void startTimer(String operation) {
    _timers[operation] = Stopwatch()..start();
  }

  /// Stop timing and record measurement
  Duration stopTimer(String operation) {
    final stopwatch = _timers.remove(operation);
    if (stopwatch == null) return Duration.zero;

    stopwatch.stop();
    final duration = stopwatch.elapsed;

    _measurements.putIfAbsent(operation, () => []).add(duration);

    if (kDebugMode) {
      print('Performance: $operation took ${duration.inMilliseconds}ms');
    }

    return duration;
  }

  /// Get average duration for an operation
  Duration getAverageDuration(String operation) {
    final measurements = _measurements[operation];
    if (measurements == null || measurements.isEmpty) return Duration.zero;

    final total = measurements.fold<Duration>(
      Duration.zero,
      (sum, duration) => sum + duration,
    );

    return Duration(milliseconds: total.inMilliseconds ~/ measurements.length);
  }

  /// Clear all measurements
  void clearMeasurements() {
    _measurements.clear();
  }

  /// Get performance report
  Map<String, dynamic> getPerformanceReport() {
    return _measurements.map((operation, durations) {
      final avg = getAverageDuration(operation);
      final min = durations.reduce((a, b) => a < b ? a : b);
      final max = durations.reduce((a, b) => a > b ? a : b);

      return MapEntry(operation, {
        'count': durations.length,
        'average': avg.inMilliseconds,
        'min': min.inMilliseconds,
        'max': max.inMilliseconds,
      });
    });
  }
}

/// Performance optimized list view with lazy loading
class OptimizedListView extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final int initialLoadCount;
  final int loadMoreCount;

  const OptimizedListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.initialLoadCount = 20,
    this.loadMoreCount = 10,
  });

  @override
  State<OptimizedListView> createState() => _OptimizedListViewState();
}

class _OptimizedListViewState extends State<OptimizedListView> {
  int _loadedCount = 0;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadedCount = widget.initialLoadCount;
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (_isLoadingMore || _loadedCount >= widget.itemCount) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Simulate async loading
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _loadedCount = (_loadedCount + widget.loadMoreCount)
              .clamp(0, widget.itemCount);
          _isLoadingMore = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _loadedCount + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _loadedCount) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        return widget.itemBuilder(context, index);
      },
    );
  }
}

/// Memory efficient image cache
class MemoryEfficientImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const MemoryEfficientImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        );
      },
      cacheWidth: width != null ? (width! * MediaQuery.of(context).devicePixelRatio).toInt() : null,
      cacheHeight: height != null ? (height! * MediaQuery.of(context).devicePixelRatio).toInt() : null,
    );
  }
}

/// Battery optimization utilities
class BatteryOptimizer {
  static const int _batchSize = 10;
  static const Duration _batchDelay = Duration(milliseconds: 16); // ~60 FPS

  /// Process items in batches to avoid blocking UI
  static Future<void> processInBatches<T>(
    List<T> items,
    Future<void> Function(List<T>) processor, {
    int batchSize = _batchSize,
  }) async {
    for (int i = 0; i < items.length; i += batchSize) {
      final batch = items.sublist(
        i,
        (i + batchSize).clamp(0, items.length),
      );

      await processor(batch);

      // Yield control to UI thread
      if (i + batchSize < items.length) {
        await Future.delayed(_batchDelay);
      }
    }
  }

  /// Debounce function calls
  static Function debounce(Function func, Duration delay) {
    Timer? timer;
    return () {
      timer?.cancel();
      timer = Timer(delay, () => func());
    };
  }

  /// Throttle function calls
  static Function throttle(Function func, Duration delay) {
    bool canCall = true;
    return () {
      if (canCall) {
        func();
        canCall = false;
        Future.delayed(delay, () => canCall = true);
      }
    };
  }
}

/// Cache manager for efficient data caching
class CacheManager {
  static final CacheManager _instance = CacheManager._internal();
  factory CacheManager() => _instance;
  CacheManager._internal();

  final Map<String, _CacheEntry> _cache = {};
  final Duration _defaultTTL = const Duration(minutes: 30);

  /// Get cached data
  T? get<T>(String key) {
    final entry = _cache[key];
    if (entry == null || entry.isExpired) {
      _cache.remove(key);
      return null;
    }
    return entry.data as T;
  }

  /// Set cached data
  void set<T>(String key, T data, {Duration? ttl}) {
    _cache[key] = _CacheEntry(
      data: data,
      expiry: DateTime.now().add(ttl ?? _defaultTTL),
    );
  }

  /// Clear expired entries
  void clearExpired() {
    _cache.removeWhere((key, entry) => entry.isExpired);
  }

  /// Clear all cache
  void clear() {
    _cache.clear();
  }

  /// Get cache size
  int get size => _cache.length;
}

class _CacheEntry {
  final dynamic data;
  final DateTime expiry;

  _CacheEntry({required this.data, required this.expiry});

  bool get isExpired => DateTime.now().isAfter(expiry);
}
