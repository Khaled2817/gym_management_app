import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:gym_management_app/core/notifications/notification_service.dart';
import 'package:gym_management_app/core/notifications/notification_channals.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message received: ${message.messageId}');
}

class FirebaseMessagingService {
  FirebaseMessagingService._();
  static final FirebaseMessagingService instance = FirebaseMessagingService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    await _requestPermission();
    await _setupForegroundHandler();
    await _setupInteractionHandlers();
    await _registerBackgroundHandler();
    await _printToken();
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    debugPrint('FCM permission status: ${settings.authorizationStatus}');
  }

  Future<void> _printToken() async {
    final token = await _messaging.getToken();
    debugPrint('FCM Token: $token');
  }

  Future<String> getToken() async {
    final token = await _messaging.getToken();
    return token ?? '';
  }

  Future<void> _registerBackgroundHandler() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  Future<void> _setupForegroundHandler() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('Foreground message received: ${message.messageId}');
      debugPrint('Foreground data: ${message.data}');
      final title = message.notification?.title ?? 'Notification';
      final body = message.notification?.body ?? 'You have a new message';
      final payload = _buildPayloadFromMessage(message);
      await NotificationService.instance.showNotification(
        notificationId: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: title,
        body: body,
        type: NotificationType.general,
        payload: payload,
      );
    });
  }

  Future<void> _setupInteractionHandlers() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification opened from background');
      final payload = _buildPayloadFromMessage(message);
      NotificationService.instance.handlePayloadString(payload);
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('App opened from terminated by notification');
      final payload = _buildPayloadFromMessage(initialMessage);
      NotificationService.instance.setInitialPayload(payload);
    }
  }

  String? _buildPayloadFromMessage(RemoteMessage message) {
    final data = message.data;
    final type = data['type'];
    final id = data['id'];
    if (type == null) return null;
    switch (type) {
      case 'login':
        return 'login|';
      case 'order':
        if (id == null) return null;
        return 'order|$id';
      case 'booking':
        if (id == null) return null;
        return 'booking|$id';
      case 'promotion':
        if (id == null) return null;
        return 'promotion|$id';
      case 'medicine':
        if (id == null) return null;
        return 'medicine|$id';
      default:
        return null;
    }
  }
}
