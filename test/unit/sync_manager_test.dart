import 'package:flutter_test/flutter_test.dart';
import 'package:mayegue/core/services/sync_manager.dart';

void main() {
  group('SyncOperation', () {

    test('should create SyncOperation with required parameters', () {
      final operation = SyncOperation(
        id: 'test-id',
        operationType: SyncOperationType.insert,
        tableName: 'users',
        recordId: 'user123',
        data: {'name': 'John'},
        timestamp: DateTime.now(),
      );

      expect(operation.id, equals('test-id'));
      expect(operation.operationType, equals(SyncOperationType.insert));
      expect(operation.tableName, equals('users'));
      expect(operation.recordId, equals('user123'));
      expect(operation.data, equals({'name': 'John'}));
      expect(operation.retryCount, equals(0));
      expect(operation.status, equals(SyncStatus.pending));
    });

    test('should serialize to JSON correctly', () {
      final timestamp = DateTime.now();
      final operation = SyncOperation(
        id: 'test-id',
        operationType: SyncOperationType.update,
        tableName: 'progress',
        recordId: 'progress123',
        data: {'score': 85},
        timestamp: timestamp,
        retryCount: 2,
        status: SyncStatus.failed,
      );

      final json = operation.toJson();

      expect(json['id'], equals('test-id'));
      expect(json['operationType'], equals('update'));
      expect(json['tableName'], equals('progress'));
      expect(json['recordId'], equals('progress123'));
      expect(json['retryCount'], equals(2));
      expect(json['status'], equals('failed'));
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'id': 'test-id',
        'operationType': 'delete',
        'tableName': 'messages',
        'recordId': 'msg123',
        'data': '{"content":"Hello"}',
        'timestamp': '2024-01-01T12:00:00.000Z',
        'retryCount': 1,
        'status': 'inProgress',
      };

      final operation = SyncOperation.fromJson(json);

      expect(operation.id, equals('test-id'));
      expect(operation.operationType, equals(SyncOperationType.delete));
      expect(operation.tableName, equals('messages'));
      expect(operation.recordId, equals('msg123'));
      expect(operation.data, equals({'content': 'Hello'}));
      expect(operation.retryCount, equals(1));
      expect(operation.status, equals(SyncStatus.inProgress));
    });

    test('should handle missing status in JSON deserialization', () {
      final json = {
        'id': 'test-id',
        'operationType': 'insert',
        'tableName': 'users',
        'recordId': 'user123',
        'data': '{"name":"John"}',
        'timestamp': '2024-01-01T12:00:00.000Z',
        'retryCount': 0,
      };

      final operation = SyncOperation.fromJson(json);
      expect(operation.status, equals(SyncStatus.pending));
    });

    test('should handle missing retryCount in JSON deserialization', () {
      final json = {
        'id': 'test-id',
        'operationType': 'update',
        'tableName': 'progress',
        'recordId': 'progress123',
        'data': '{"score":85}',
        'timestamp': '2024-01-01T12:00:00.000Z',
        'status': 'pending',
      };

      final operation = SyncOperation.fromJson(json);
      expect(operation.retryCount, equals(0));
    });
  });

  group('SyncManager', () {
    late SyncManager syncManager;

    setUp(() {
      syncManager = SyncManager();
    });

    test('should initialize without throwing errors', () async {
      expect(() async => await syncManager.initialize(), returnsNormally);
    });

    test('should dispose without throwing errors', () {
      expect(() => syncManager.dispose(), returnsNormally);
    });

    test('syncStatus should be a broadcast stream', () {
      expect(syncManager.syncStatus.isBroadcast, isTrue);
    });

    test('queueOperation should complete without error', () async {
      final operation = SyncOperation(
        id: 'test-op',
        operationType: SyncOperationType.insert,
        tableName: 'test_table',
        recordId: 'test-record',
        data: {'test': 'data'},
        timestamp: DateTime.now(),
      );

      expect(syncManager.queueOperation(operation), completes);
    });

    test('syncNow should complete without error', () async {
      expect(syncManager.syncNow(), completes);
    });

    test('getPendingOperationsCount should return a Future<int>', () async {
      final result = syncManager.getPendingOperationsCount();
      expect(result, isA<Future<int>>());
    });
  });

  group('SyncOperationType enum', () {
    test('should have correct values', () {
      expect(SyncOperationType.insert.name, equals('insert'));
      expect(SyncOperationType.update.name, equals('update'));
      expect(SyncOperationType.delete.name, equals('delete'));
    });
  });

  group('SyncStatus enum', () {
    test('should have correct values', () {
      expect(SyncStatus.pending.name, equals('pending'));
      expect(SyncStatus.inProgress.name, equals('inProgress'));
      expect(SyncStatus.success.name, equals('success'));
      expect(SyncStatus.failed.name, equals('failed'));
    });
  });
}