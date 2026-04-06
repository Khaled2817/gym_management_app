import 'notification_payload_data.dart';
import 'notification_payload_type.dart';

class NotificationPayloadParser {
  static NotificationPayloadData parse(String? payload) {
    if (payload == null || payload.trim().isEmpty) {
      return const NotificationPayloadData(
        type: NotificationPayloadType.unknown,
      );
    }

    final parts = payload.split('|');
    final rawType = parts.isNotEmpty ? parts[0].trim() : '';
    final rawValue = parts.length > 1 ? parts[1].trim() : null;

    switch (rawType) {
      case 'login':
        return NotificationPayloadData(
          type: NotificationPayloadType.login,
          value: rawValue,
        );

      case 'order':
        return NotificationPayloadData(
          type: NotificationPayloadType.order,
          value: rawValue,
        );

      case 'promotion':
        return NotificationPayloadData(
          type: NotificationPayloadType.promotion,
          value: rawValue,
        );

      case 'booking':
        return NotificationPayloadData(
          type: NotificationPayloadType.booking,
          value: rawValue,
        );

      case 'attendance':
        return NotificationPayloadData(
          type: NotificationPayloadType.attendance,
          value: rawValue,
        );

      default:
        return NotificationPayloadData(
          type: NotificationPayloadType.unknown,
          value: rawValue,
        );
    }
  }
}