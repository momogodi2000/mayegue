import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import 'firebase_service.dart';

/// Sync operation types
enum SyncOperationType {
  insert,
  update,
  delete,
}

/// Sync status
enum SyncStatus {
  pending,
  inProgress,
  success,
  failed,
}

/// Sync operation model
class SyncOperation {
  final String id;
  final SyncOperationType operationType;
  final String tableName;
  final String recordId;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final int retryCount;
  final SyncStatus status;

  SyncOperation({
    required this.id,
    required this.operationType,
    required this.tableName,
    required this.recordId,
    required this.data,
    required this.timestamp,
    this.retryCount = 0,
    this.status = SyncStatus.pending,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'operationType': operationType.name,
      'tableName': tableName,
      'recordId': recordId,
      'data': jsonEncode(data),
      'timestamp': timestamp.toIso8601String(),
      'retryCount': retryCount,
      'status': status.name,
    };
  }

  factory SyncOperation.fromJson(Map<String, dynamic> json) {
    return SyncOperation(
      id: json['id'],
      operationType: SyncOperationType.values.firstWhere(
        (e) => e.name == json['operationType'],
      ),
      tableName: json['tableName'],
      recordId: json['recordId'],
      data: jsonDecode(json['data']),
      timestamp: DateTime.parse(json['timestamp']),
      retryCount: json['retryCount'] ?? 0,
      status: SyncStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => SyncStatus.pending,
      ),
    );
  }
}

/// Sync manager for handling offline/online data synchronization
class SyncManager {
  static const int _maxRetries = 3;
  static const Duration _syncInterval = Duration(minutes: 5);

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final FirebaseService _firebaseService = FirebaseService();
  final Connectivity _connectivity = Connectivity();

  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  Timer? _syncTimer;

  final StreamController<SyncStatus> _syncStatusController =
      StreamController<SyncStatus>.broadcast();

  Stream<SyncStatus> get syncStatus => _syncStatusController.stream;

  /// Initialize sync manager
  Future<void> initialize() async {
    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _onConnectivityChanged,
    );

    // Start periodic sync
    _startPeriodicSync();

    // Initial sync check
    await _checkConnectivityAndSync();
  }

  /// Dispose sync manager
  void dispose() {
    _connectivitySubscription?.cancel();
    _syncTimer?.cancel();
    _syncStatusController.close();
  }

  /// Queue operation for sync
  Future<void> queueOperation(SyncOperation operation) async {
    final db = await _dbHelper.database;

    await db.insert(
      'sync_operations',
      operation.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Try to sync immediately if online
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      await _performSync();
    }
  }

  /// Manual sync trigger
  Future<void> syncNow() async {
    await _performSync();
  }

  /// Get pending operations count
  Future<int> getPendingOperationsCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM sync_operations WHERE status = ?',
      [SyncStatus.pending.name],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Handle connectivity changes
  void _onConnectivityChanged(ConnectivityResult result) {
    if (result != ConnectivityResult.none) {
      // Back online, trigger sync
      _performSync();
    }
  }

  /// Start periodic sync
  void _startPeriodicSync() {
    _syncTimer = Timer.periodic(_syncInterval, (_) {
      _checkConnectivityAndSync();
    });
  }

  /// Check connectivity and sync if online
  Future<void> _checkConnectivityAndSync() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      await _performSync();
    }
  }

  /// Perform synchronization
  Future<void> _performSync() async {
    _syncStatusController.add(SyncStatus.inProgress);

    try {
      final db = await _dbHelper.database;

      // Get pending operations
      final operations = await db.query(
        'sync_operations',
        where: 'status = ? AND retry_count < ?',
        whereArgs: [SyncStatus.pending.name, _maxRetries],
        orderBy: 'timestamp ASC',
      );

      for (final operationJson in operations) {
        final operation = SyncOperation.fromJson(operationJson);

        try {
          await _executeOperation(operation);

          // Mark as success
          await db.update(
            'sync_operations',
            {'status': SyncStatus.success.name},
            where: 'id = ?',
            whereArgs: [operation.id],
          );
        } catch (e) {
          // Increment retry count
          final newRetryCount = operation.retryCount + 1;

          if (newRetryCount >= _maxRetries) {
            // Mark as failed
            await db.update(
              'sync_operations',
              {
                'status': SyncStatus.failed.name,
                'retry_count': newRetryCount,
              },
              where: 'id = ?',
              whereArgs: [operation.id],
            );
          } else {
            // Update retry count
            await db.update(
              'sync_operations',
              {'retry_count': newRetryCount},
              where: 'id = ?',
              whereArgs: [operation.id],
            );
          }
        }
      }

      // Sync data from Firebase to local
      await _syncFromFirebase();

      _syncStatusController.add(SyncStatus.success);
    } catch (e) {
      _syncStatusController.add(SyncStatus.failed);
    }
  }

  /// Execute sync operation
  Future<void> _executeOperation(SyncOperation operation) async {
    switch (operation.operationType) {
      case SyncOperationType.insert:
        await _syncInsert(operation);
        break;
      case SyncOperationType.update:
        await _syncUpdate(operation);
        break;
      case SyncOperationType.delete:
        await _syncDelete(operation);
        break;
    }
  }

  /// Sync insert operation
  Future<void> _syncInsert(SyncOperation operation) async {
    switch (operation.tableName) {
      case 'users':
        await _firebaseService.firestore
            .collection('users')
            .doc(operation.recordId)
            .set(operation.data);
        break;
      case 'progress':
        await _firebaseService.firestore
            .collection('progress')
            .doc(operation.recordId)
            .set(operation.data);
        break;
      case 'chat_messages':
        await _firebaseService.firestore
            .collection('chat_messages')
            .doc(operation.recordId)
            .set(operation.data);
        break;
      // Add other tables as needed
    }
  }

  /// Sync update operation
  Future<void> _syncUpdate(SyncOperation operation) async {
    switch (operation.tableName) {
      case 'users':
        await _firebaseService.firestore
            .collection('users')
            .doc(operation.recordId)
            .update(operation.data);
        break;
      case 'progress':
        await _firebaseService.firestore
            .collection('progress')
            .doc(operation.recordId)
            .update(operation.data);
        break;
      // Add other tables as needed
    }
  }

  /// Sync delete operation
  Future<void> _syncDelete(SyncOperation operation) async {
    switch (operation.tableName) {
      case 'users':
        await _firebaseService.firestore
            .collection('users')
            .doc(operation.recordId)
            .delete();
        break;
      case 'progress':
        await _firebaseService.firestore
            .collection('progress')
            .doc(operation.recordId)
            .delete();
        break;
      // Add other tables as needed
    }
  }

  /// Sync data from Firebase to local database
  Future<void> _syncFromFirebase() async {
    final db = await _dbHelper.database;
    final user = _firebaseService.auth.currentUser;

    if (user == null) return;

    try {
      // Sync user data
      final userDoc = await _firebaseService.firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
        userData['last_sync'] = DateTime.now().toIso8601String();
        userData['is_synced'] = 1;

        await db.insert(
          'users',
          userData,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Sync progress data
      final progressQuery = await _firebaseService.firestore
          .collection('progress')
          .where('user_id', isEqualTo: user.uid)
          .get();

      for (final doc in progressQuery.docs) {
        final progressData = doc.data();
        progressData['id'] = doc.id;
        progressData['last_sync'] = DateTime.now().toIso8601String();
        progressData['is_synced'] = 1;

        await db.insert(
          'progress',
          progressData,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Add sync for other collections as needed
    } catch (e) {
      // Handle sync errors
    }
  }

  /// Resolve conflicts (last-write-wins strategy)
  Future<void> resolveConflicts() async {
    final db = await _dbHelper.database;

    // Get conflicting records (same ID, different timestamps)
    final conflicts = await db.rawQuery('''
      SELECT * FROM sync_operations
      WHERE status = ?
      GROUP BY record_id
      HAVING COUNT(*) > 1
      ORDER BY timestamp DESC
    ''', [SyncStatus.pending.name]);

    for (final conflict in conflicts) {
      // Keep the most recent operation, mark others as failed
      final recordId = conflict['record_id'] as String;
      await db.rawUpdate('''
        UPDATE sync_operations
        SET status = ?
        WHERE record_id = ? AND id != ?
      ''', [SyncStatus.failed.name, recordId, conflict['id']]);
    }
  }
}
