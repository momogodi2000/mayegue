import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Types of sync operations
enum SyncOperationType {
  insert,
  update,
  delete;

  String get name => toString().split('.').last;
}

/// Status of sync operations
enum SyncStatus {
  pending,
  inProgress,
  success,
  failed;

  String get name => toString().split('.').last;
}

/// Represents a sync operation to be performed
class SyncOperation {
  final String id;
  final SyncOperationType operationType;
  final String tableName;
  final String recordId;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final int retryCount;
  final SyncStatus status;
  final String? errorMessage;

  const SyncOperation({
    required this.id,
    required this.operationType,
    required this.tableName,
    required this.recordId,
    required this.data,
    required this.timestamp,
    this.retryCount = 0,
    this.status = SyncStatus.pending,
    this.errorMessage,
  });

  /// Create a copy with modified fields
  SyncOperation copyWith({
    String? id,
    SyncOperationType? operationType,
    String? tableName,
    String? recordId,
    Map<String, dynamic>? data,
    DateTime? timestamp,
    int? retryCount,
    SyncStatus? status,
    String? errorMessage,
  }) {
    return SyncOperation(
      id: id ?? this.id,
      operationType: operationType ?? this.operationType,
      tableName: tableName ?? this.tableName,
      recordId: recordId ?? this.recordId,
      data: data ?? this.data,
      timestamp: timestamp ?? this.timestamp,
      retryCount: retryCount ?? this.retryCount,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'operationType': operationType.name,
      'tableName': tableName,
      'recordId': recordId,
      'data': data,
      'timestamp': timestamp.toIso8601String(),
      'retryCount': retryCount,
      'status': status.name,
      'errorMessage': errorMessage,
    };
  }

  /// Create from JSON
  factory SyncOperation.fromJson(Map<String, dynamic> json) {
    return SyncOperation(
      id: json['id'],
      operationType: SyncOperationType.values.firstWhere(
        (e) => e.name == json['operationType'],
      ),
      tableName: json['tableName'],
      recordId: json['recordId'],
      data: Map<String, dynamic>.from(json['data']),
      timestamp: DateTime.parse(json['timestamp']),
      retryCount: json['retryCount'] ?? 0,
      status: SyncStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => SyncStatus.pending,
      ),
      errorMessage: json['errorMessage'],
    );
  }
}

/// Manages offline-to-online synchronization of data
class SyncManager {
  static const String _operationsKey = 'sync_operations';
  static const int _maxRetries = 3;
  static const Duration _syncInterval = Duration(minutes: 5);

  final StreamController<SyncStatus> _syncStatusController = StreamController<SyncStatus>.broadcast();
  final Connectivity _connectivity = Connectivity();

  SharedPreferences? _prefs;
  Timer? _syncTimer;
  bool _isInitialized = false;

  /// Stream of sync status updates
  Stream<SyncStatus> get syncStatus => _syncStatusController.stream;

  /// Initialize the sync manager
  Future<void> initialize() async {
    if (_isInitialized) return;

    _prefs = await SharedPreferences.getInstance();

    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);

    // Start periodic sync
    _startPeriodicSync();

    _isInitialized = true;
  }

  /// Dispose of resources
  void dispose() {
    _syncTimer?.cancel();
    _syncStatusController.close();
  }

  /// Queue a sync operation for later execution
  Future<void> queueOperation(SyncOperation operation) async {
    final operations = await _getQueuedOperations();
    operations.add(operation);
    await _saveQueuedOperations(operations);
  }

  /// Force immediate synchronization
  Future<void> syncNow() async {
    if (!await _isOnline()) {
      _syncStatusController.add(SyncStatus.failed);
      return;
    }

    _syncStatusController.add(SyncStatus.inProgress);

    try {
      final operations = await _getQueuedOperations();
      final successfulOps = <SyncOperation>[];
      final failedOps = <SyncOperation>[];

      for (final operation in operations) {
        try {
          await _executeOperation(operation);
          successfulOps.add(operation.copyWith(status: SyncStatus.success));
        } catch (e) {
          final retryCount = operation.retryCount + 1;
          if (retryCount >= _maxRetries) {
            failedOps.add(operation.copyWith(
              status: SyncStatus.failed,
              errorMessage: e.toString(),
            ));
          } else {
            // Re-queue for retry
            await queueOperation(operation.copyWith(retryCount: retryCount));
          }
        }
      }

      // Update stored operations
      final remainingOps = operations
          .where((op) => !successfulOps.any((success) => success.id == op.id))
          .where((op) => !failedOps.any((failed) => failed.id == op.id))
          .toList();

      await _saveQueuedOperations(remainingOps);
      _syncStatusController.add(SyncStatus.success);
    } catch (e) {
      _syncStatusController.add(SyncStatus.failed);
      debugPrint('Sync failed: $e');
    }
  }

  /// Get the count of pending operations
  Future<int> getPendingOperationsCount() async {
    final operations = await _getQueuedOperations();
    return operations.where((op) => op.status == SyncStatus.pending).length;
  }

  /// Clear all queued operations (use with caution)
  Future<void> clearQueue() async {
    if (_prefs != null) {
      await _prefs!.remove(_operationsKey);
    }
  }

  void _startPeriodicSync() {
    _syncTimer = Timer.periodic(_syncInterval, (_) {
      syncNow();
    });
  }

  void _onConnectivityChanged(ConnectivityResult result) {
    if (result != ConnectivityResult.none) {
      // Trigger sync when connection is restored
      syncNow();
    }
  }

  Future<bool> _isOnline() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<List<SyncOperation>> _getQueuedOperations() async {
    if (_prefs == null) return [];
    final operationsJson = _prefs!.getStringList(_operationsKey) ?? [];
    return operationsJson
        .map((json) => SyncOperation.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> _saveQueuedOperations(List<SyncOperation> operations) async {
    if (_prefs == null) return;
    final operationsJson = operations
        .map((op) => jsonEncode(op.toJson()))
        .toList();
    await _prefs!.setStringList(_operationsKey, operationsJson);
  }

  Future<void> _executeOperation(SyncOperation operation) async {
    // This is a placeholder - in a real implementation, this would
    // execute the operation against the appropriate backend service
    // For now, we'll just simulate success
    await Future.delayed(const Duration(milliseconds: 100));
  }
}