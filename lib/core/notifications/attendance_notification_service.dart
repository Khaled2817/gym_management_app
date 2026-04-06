import 'package:gym_management_app/core/notifications/notification_payload_builder.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// خدمة الإشعارات الخاصة بالحضور والانصراف
class AttendanceNotificationService {
  AttendanceNotificationService._();
  static final AttendanceNotificationService instance =
      AttendanceNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // معرفات الإشعارات
  static const int _checkInReminderId = 1000;
  static const int _checkOutReminderId = 1001;
  static const int _checkInRepeatBaseId = 2000;
  static const int _checkOutRepeatBaseId = 3000;

  // إعدادات عامة
  static const int _repeatIntervalMinutes = 30; // كل نصف ساعة
  static const int _workHours = 8; // بعد 8 ساعات من الحضور

  tz.TZDateTime _endOfDay(tz.TZDateTime anchor) => tz.TZDateTime(
    tz.local,
    anchor.year,
    anchor.month,
    anchor.day,
  ).add(const Duration(days: 1));

  /// تهيئة خدمة الإشعارات
  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    tz_data.initializeTimeZones();
    await _plugin.initialize(settings: initSettings);
    await _requestPermissions();
    await _requestExactAlarmPermissionIfNeeded();
  }

  Future<void> _requestPermissions() async {
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

  Future<void> _requestExactAlarmPermissionIfNeeded() async {
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

  /// إشعار اختبار سريع بعد [seconds] ثانية
  Future<void> testNotification({int seconds = 10}) async {
    final scheduledDate = tz.TZDateTime.now(
      tz.local,
    ).add(Duration(seconds: seconds));

    await _plugin.zonedSchedule(
      id: 9999,
      title: 'اختبار الإشعارات',
      body: 'الإشعار وصل بعد $seconds ثانية!',
      scheduledDate: scheduledDate,
      notificationDetails: _notificationDetails(),
      payload: NotificationPayloadBuilder.attendance(action: 'test'),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// تذكير يومي بالحضور (يُتخطّى يوم الجمعة)
  Future<void> scheduleCheckInReminder({
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = _nextValidWeekday(hour: hour, minute: minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
      while (scheduledDate.weekday == DateTime.friday) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
    }

    await _plugin.zonedSchedule(
      id: _checkInReminderId,
      title: 'تذكير بتسجيل الحضور',
      body: 'لا تنسَ تسجيل حضورك الآن',
      scheduledDate: scheduledDate,
      notificationDetails: _notificationDetails(),
      payload: NotificationPayloadBuilder.attendance(action: 'check_in'),
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    await _scheduleCheckInRepeatReminders(startFrom: scheduledDate);
  }

  /// تذكيرات متكررة للحضور كل نصف ساعة حتى منتصف الليل أو حتى تسجيل الحضور
  Future<void> _scheduleCheckInRepeatReminders({
    required tz.TZDateTime startFrom,
  }) async {
    await cancelCheckInRepeatReminders();

    final now = tz.TZDateTime.now(tz.local);
    final interval = const Duration(minutes: _repeatIntervalMinutes);
    var nextReminder = startFrom.isAfter(now) ? startFrom : now;
    nextReminder = nextReminder.add(interval);

    final endOfDay = _endOfDay(nextReminder);
    int index = 0;

    while (nextReminder.isBefore(endOfDay) && index < 48) {
      if (nextReminder.weekday == DateTime.friday) {
        nextReminder = nextReminder.add(const Duration(days: 1));
        continue;
      }

      await _plugin.zonedSchedule(
        id: (_checkInRepeatBaseId + index).toInt(),
        title: 'تذكير بتسجيل الحضور',
        body: 'لم تسجل حضورك بعد، سجّل الآن',
        scheduledDate: nextReminder,
        notificationDetails: _notificationDetails(),
        payload: NotificationPayloadBuilder.attendance(action: 'check_in'),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      nextReminder = nextReminder.add(interval);
      index++;
    }
  }

  /// تذكير أساسي بالانصراف بعد 8 ساعات من تسجيل الحضور
  Future<void> scheduleCheckOutReminderAfterCheckIn() async {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = now.add(const Duration(hours: _workHours));

    await _plugin.zonedSchedule(
      id: _checkOutReminderId,
      title: 'تذكير بتسجيل الانصراف',
      body: 'مرت 8 ساعات على حضورك، لا تنسَ تسجيل انصرافك',
      scheduledDate: scheduledDate,
      notificationDetails: _notificationDetails(),
      payload: NotificationPayloadBuilder.attendance(action: 'check_out'),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    await cancelCheckInRepeatReminders();
    await _scheduleCheckOutRepeatReminders(startFrom: scheduledDate);
  }

  /// تذكيرات متكررة بالانصراف كل نصف ساعة حتى منتصف الليل أو حتى تسجيل الانصراف
  Future<void> _scheduleCheckOutRepeatReminders({
    required tz.TZDateTime startFrom,
  }) async {
    final interval = const Duration(minutes: _repeatIntervalMinutes);
    var nextReminder = startFrom.add(interval);
    final endOfDay = _endOfDay(nextReminder);

    int index = 0;
    while (nextReminder.isBefore(endOfDay) && index < 48) {
      await _plugin.zonedSchedule(
        id: (_checkOutRepeatBaseId + index).toInt(),
        title: 'تذكير بتسجيل الانصراف',
        body: 'لم تسجل انصرافك بعد، سجّل الآن',
        scheduledDate: nextReminder,
        notificationDetails: _notificationDetails(),
        payload: NotificationPayloadBuilder.attendance(action: 'check_out'),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      nextReminder = nextReminder.add(interval);
      index++;
    }
  }

  Future<void> cancelCheckInRepeatReminders() async {
    for (int i = 0; i < 48; i++) {
      await _plugin.cancel(id: (_checkInRepeatBaseId + i).toInt());
    }
  }

  Future<void> cancelCheckOutRepeatReminders() async {
    for (int i = 0; i < 48; i++) {
      await _plugin.cancel(id: (_checkOutRepeatBaseId + i).toInt());
    }
  }

  Future<void> cancelAllAttendanceNotifications() async {
    await _plugin.cancel(id: _checkInReminderId);
    await _plugin.cancel(id: _checkOutReminderId);
    await cancelCheckInRepeatReminders();
    await cancelCheckOutRepeatReminders();
  }

  Future<void> scheduleAllAttendanceNotifications({
    int checkInHour = 9,
    int checkInMinute = 0,
  }) async {
    await scheduleCheckInReminder(hour: checkInHour, minute: checkInMinute);
  }

  Future<void> onCheckIn() async {
    await cancelCheckInRepeatReminders();
    await scheduleCheckOutReminderAfterCheckIn();
  }

  Future<void> onCheckOut() async {
    await cancelAllAttendanceNotifications();
  }

  tz.TZDateTime _nextValidWeekday({required int hour, required int minute}) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // إذا كان اليوم جمعة انتقل لليوم التالي (السبت)
    if (scheduledDate.weekday == DateTime.friday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  NotificationDetails _notificationDetails() {
    const androidDetails = AndroidNotificationDetails(
      'attendance_channel',
      'Attendance Notifications',
      channelDescription: 'Notifications for check-in and check-out reminders',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails();
    return const NotificationDetails(android: androidDetails, iOS: iosDetails);
  }
}
