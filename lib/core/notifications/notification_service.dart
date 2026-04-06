import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gym_management_app/core/helpers/app_navigator.dart';
import 'package:gym_management_app/core/notifications/notification_channals.dart';
import 'package:gym_management_app/core/notifications/notification_payload_data.dart';
import 'package:gym_management_app/core/notifications/notification_payload_parser.dart';
import 'package:gym_management_app/core/notifications/notification_payload_type.dart';
import 'package:gym_management_app/core/routing/routers.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  String? _initialPayloadString;
  NotificationResponse? _initialNotificationResponse;

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    tz.initializeTimeZones();
    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    await requestPermissions();
    await requestExactAlarmPermissionIfNeeded();
    await checkForInitialNotification();
  }

  Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> checkForInitialNotification() async {
    final details = await _plugin.getNotificationAppLaunchDetails();

    final didLaunchFromNotification =
        details?.didNotificationLaunchApp ?? false;

    if (!didLaunchFromNotification) return;

    _initialNotificationResponse = details?.notificationResponse;
  }

  void handleInitialNotificationIfNeeded() {
    final response = _initialNotificationResponse;
    if (response == null) return;
    _initialNotificationResponse = null;
    _handleNotificationNavigation(response);
  }

  void _onNotificationTap(NotificationResponse response) {
    _handleNotificationNavigation(response);
  }

  void _handleNotificationNavigation(NotificationResponse response) {
    final payloadData = NotificationPayloadParser.parse(response.payload);
    _handleParsedPayload(payloadData, rawPayload: response.payload);
  }

  NotificationDetails _notificationDetails(NotificationType type) {
    final channelData = getChannelData(type);

    final androidDetails = AndroidNotificationDetails(
      channelData.id,
      channelData.name,
      channelDescription: channelData.description,
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    return NotificationDetails(android: androidDetails, iOS: iosDetails);
  }

  Future<void> showNotification({
    required int notificationId,
    required String title,
    required String body,
    required NotificationType type,
    String? payload,
  }) async {
    await _plugin.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: _notificationDetails(type),
      payload: payload,
    );
  }

  Future<void> cancel(int notificationId) async {
    await _plugin.cancel(id: notificationId);
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  void handlePayloadString(String? payload) {
    if (payload == null || payload.isEmpty) return;

    final payloadData = NotificationPayloadParser.parse(payload);
    _handleParsedPayload(payloadData, rawPayload: payload);
  }

  void _handleParsedPayload(
    NotificationPayloadData payloadData, {
    String? rawPayload,
  }) {
    switch (payloadData.type) {
      case NotificationPayloadType.login:
        navigatorKey.currentState?.pushNamed(Routers.loginScreen);
        break;

      case NotificationPayloadType.order:
        final orderId = payloadData.value;
        if (orderId == null || orderId.isEmpty) return;

        navigatorKey.currentState?.pushNamed(
          Routers.loginScreen,
          arguments: orderId,
        );
        break;

      case NotificationPayloadType.promotion:
        final promotionId = payloadData.value;
        if (promotionId == null || promotionId.isEmpty) return;

        navigatorKey.currentState?.pushNamed(
          Routers.loginScreen,
          arguments: promotionId,
        );
        break;

      case NotificationPayloadType.booking:
        final bookingId = payloadData.value;
        if (bookingId == null || bookingId.isEmpty) return;

        navigatorKey.currentState?.pushNamed(
          Routers.loginScreen,
          arguments: bookingId,
        );
        break;

      case NotificationPayloadType.attendance:
        // Navigate to main home which contains attendance registration
        navigatorKey.currentState?.pushNamed(Routers.mainHome);
        break;

      case NotificationPayloadType.unknown:
        debugPrint('Unknown payload: $rawPayload');
        break;
    }
  }

  void setInitialPayload(String? payload) {
    if (payload == null || payload.isEmpty) return;
    _initialPayloadString = payload;
  }

  void handleInitialPayloadIfNeeded() {
    final payload = _initialPayloadString;
    if (payload == null || payload.isEmpty) return;

    _initialPayloadString = null;
    handlePayloadString(payload);
  }

  //-------------------------------------------- Notification Scheduling
  tz.TZDateTime _nextInstanceOfTime({required int hour, required int minute}) {
    final now = tz.TZDateTime.now(tz.local);

    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  Future<void> scheduleDailyNotification({
    required int notificationId,
    required String title,
    required String body,
    required NotificationType type,
    required int hour,
    required int minute,
    String? payload,
  }) async {
    await _plugin.zonedSchedule(
      id: notificationId,
      title: title,
      body: body,
      scheduledDate: _nextInstanceOfTime(hour: hour, minute: minute),
      notificationDetails: _notificationDetails(type),
      payload: payload,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> scheduleMorningAndEveningNotifications() async {
    await scheduleDailyNotification(
      notificationId: 100,
      title: 'Morning Reminder',
      body: 'Good morning, check your tasks',
      type: NotificationType.general,
      hour: 9,
      minute: 0,
      payload: 'login|',
    );

    await scheduleDailyNotification(
      notificationId: 101,
      title: 'Evening Reminder',
      body: 'Good evening, don’t forget your follow-up',
      type: NotificationType.general,
      hour: 21,
      minute: 0,
      payload: 'login|',
    );
  }

  Future<void> requestExactAlarmPermissionIfNeeded() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final canScheduleExact =
        await androidPlugin?.canScheduleExactNotifications() ?? false;

    if (!canScheduleExact) {
      await androidPlugin?.requestExactAlarmsPermission();
    }
  }

  Future<void> scheduleAfterOneMinuteTest() async {
    final scheduledDate = tz.TZDateTime.now(
      tz.local,
    ).add(const Duration(minutes: 1));
    await _plugin.zonedSchedule(
      id: 999,
      title: 'Test Notification',
      body: 'This is a scheduled test',
      scheduledDate: scheduledDate,
      notificationDetails: _notificationDetails(NotificationType.general),
      payload: '',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  //   Future<void> scheduleMedicineReminders({
  //   required MedicineReminderModel medicine,
  // }) async {
  //   for (int i = 0; i < medicine.doseTimes.length; i++) {
  //     final doseTime = medicine.doseTimes[i];

  //     await scheduleDailyNotification(
  //       notificationId: _buildMedicineNotificationId(
  //         medicineId: medicine.medicineId,
  //         index: i,
  //       ),
  //       title: 'Medicine Reminder',
  //       body: 'Time to take ${medicine.medicineName}',
  //       type: NotificationType.general,
  //       hour: doseTime.hour,
  //       minute: doseTime.minute,
  //       payload: 'medicine|${medicine.medicineId}',
  //     );
  //   }
  // }
}

// int _buildMedicineNotificationId({
//   required int medicineId,
//   required int index,
// }) {
//   return (medicineId * 10) + index;
// }
