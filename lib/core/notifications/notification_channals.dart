class NotificationChannels {
  static const String generalId = 'general_channel';
  static const String generalName = 'General Notifications';
  static const String generalDescription = 'General app notifications';
  static const String ordersId = 'orders_channel';
  static const String ordersName = 'Orders Notifications';
  static const String ordersDescription = 'Notifications related to orders and order updates';
  static const String attendanceId = 'attendance_channel';
  static const String attendanceName = 'Attendance Notifications';
  static const String attendanceDescription = 'Notifications for check-in and check-out reminders';
}
enum NotificationType {
  general,
  orders,
  attendance,
}

class NotificationChannelData {
  final String id;
  final String name;
  final String description;

  const NotificationChannelData({
    required this.id,
    required this.name,
    required this.description,
  });
}

NotificationChannelData getChannelData(NotificationType type) {
  switch (type) {
    case NotificationType.orders:
      return const NotificationChannelData(
        id: 'orders_channel',
        name: 'Orders Notifications',
        description: 'Notifications related to orders and order updates',
      );

    case NotificationType.attendance:
      return const NotificationChannelData(
        id: 'attendance_channel',
        name: 'Attendance Notifications',
        description: 'Notifications for check-in and check-out reminders',
      );

    case NotificationType.general:
      return const NotificationChannelData(
        id: 'general_channel',
        name: 'General Notifications',
        description: 'General app notifications',
      );
  }
}