import 'package:gym_management_app/feature/notification/data/model/notification_model.dart';

abstract class NotificationStates {}

class NotificationInitial extends NotificationStates {}

class NotificationLoading extends NotificationStates {}

class NotificationLoaded extends NotificationStates {
  final List<NotificationModel> notifications;

  NotificationLoaded(this.notifications);
}

class NotificationEmpty extends NotificationStates {}

class NotificationError extends NotificationStates {
  final String error;

  NotificationError(this.error);
}

// Alias for compatibility
typedef NotificationEmptyState = NotificationEmpty;
