enum NotificationType {
  general,
  attendance,
  reminder,
  alert,
}

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime time;
  final bool isRead;
  final NotificationType type;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
    required this.type,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      time: json['time'] != null
          ? DateTime.parse(json['time'].toString())
          : DateTime.now(),
      isRead: json['isRead'] ?? json['is_read'] ?? false,
      type: _parseType(json['type']?.toString()),
    );
  }

  static NotificationType _parseType(String? type) {
    switch (type?.toLowerCase()) {
      case 'attendance':
        return NotificationType.attendance;
      case 'reminder':
        return NotificationType.reminder;
      case 'alert':
        return NotificationType.alert;
      default:
        return NotificationType.general;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'time': time.toIso8601String(),
      'isRead': isRead,
      'type': type.name,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? time,
    bool? isRead,
    NotificationType? type,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
    );
  }
}
