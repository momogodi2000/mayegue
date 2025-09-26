import 'package:flutter_test/flutter_test.dart';
import 'package:mayegue/core/services/notification_service.dart';

void main() {
  late NotificationService notificationService;

  setUp(() {
    notificationService = NotificationService();
  });

  group('NotificationService', () {
    test('should be a singleton', () {
      final instance1 = NotificationService();
      final instance2 = NotificationService();
      expect(instance1, same(instance2));
    });

    test('should initialize without throwing errors', () async {
      // Test that initialize doesn't throw unhandled exceptions
      // Note: Full initialization testing would require mocking Firebase and platform dependencies
      expect(() async => await notificationService.initialize(), returnsNormally);
    });

    test('getFCMToken should return a Future<String?>', () async {
      final result = notificationService.getFCMToken();
      expect(result, isA<Future<String?>>());
    });

    test('subscribeToTopic should complete without error', () async {
      expect(notificationService.subscribeToTopic('test-topic'), completes);
    });

    test('unsubscribeFromTopic should complete without error', () async {
      expect(notificationService.unsubscribeFromTopic('test-topic'), completes);
    });
  });
}