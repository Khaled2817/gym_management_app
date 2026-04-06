import 'package:gym_management_app/core/notifications/notification_payload_type.dart';

class NotificationPayloadData {
  final NotificationPayloadType type;
  final String? value;
  const NotificationPayloadData({required this.type, this.value});
}
