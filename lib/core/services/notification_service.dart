import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service for handling push notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  late final FirebaseMessaging _firebaseMessaging;
  late final FlutterLocalNotificationsPlugin _localNotifications;

  bool _initialized = false;

  /// Initialize notification services
  Future<void> initialize() async {
    if (_initialized) return;

    _firebaseMessaging = FirebaseMessaging.instance;
    _localNotifications = FlutterLocalNotificationsPlugin();

    // Request permissions
    await _requestPermissions();

    // Configure local notifications
    await _configureLocalNotifications();

    // Configure Firebase messaging
    await _configureFirebaseMessaging();

    _initialized = true;
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    // Request Firebase permission
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Request local permission
    final status = await Permission.notification.request();
    if (status.isDenied) {
      // Handle denied permission
    }
  }

  /// Configure local notifications
  Future<void> _configureLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(settings);
  }

  /// Configure Firebase messaging
  Future<void> _configureFirebaseMessaging() async {
    // Get FCM token
    // final token = await _firebaseMessaging.getToken();
    // TODO: Send token to server

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background messages
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Handle initial message
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    // Show local notification
    _showLocalNotification(message);
  }

  /// Handle message opened app
  void _handleMessageOpenedApp(RemoteMessage message) {
    // Navigate to appropriate screen based on message data
    // final data = message.data;
    // TODO: Implement navigation logic
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'main_channel',
      'Main Channel',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'Notification',
      message.notification?.body ?? '',
      details,
      payload: message.data.toString(),
    );
  }

  /// Get FCM token
  Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}