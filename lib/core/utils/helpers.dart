import 'dart:convert';
import 'dart:math';

import 'dart:async';

/// General helper utilities
class Helpers {
  /// Generate a random string
  static String generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  /// Generate a unique ID
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
           generateRandomString(8);
  }

  /// Check if string is null or empty
  static bool isNullOrEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  /// Safe JSON decode
  static dynamic safeJsonDecode(String json) {
    try {
      return jsonDecode(json);
    } catch (e) {
      return null;
    }
  }

  /// Safe JSON encode
  static String safeJsonEncode(dynamic data) {
    try {
      return jsonEncode(data);
    } catch (e) {
      return '{}';
    }
  }

  /// Calculate percentage
  static double calculatePercentage(int value, int total) {
    if (total == 0) return 0.0;
    return (value / total) * 100;
  }

  /// Clamp value between min and max
  static double clamp(double value, double min, double max) {
    return value.clamp(min, max);
  }

  /// Get file extension from path
  static String getFileExtension(String path) {
    return path.split('.').last.toLowerCase();
  }

  /// Check if URL is valid
  static bool isValidUrl(String url) {
    try {
      Uri.parse(url);
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Debounce utility for search
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 300)});

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void cancel() {
    _timer?.cancel();
  }
}

/// Throttle utility
class Throttler {
  final Duration delay;
  Timer? _timer;
  bool _isThrottled = false;

  Throttler({this.delay = const Duration(milliseconds: 300)});

  void run(void Function() action) {
    if (_isThrottled) return;

    action();
    _isThrottled = true;
    _timer = Timer(delay, () => _isThrottled = false);
  }

  void cancel() {
    _timer?.cancel();
    _isThrottled = false;
  }
}
