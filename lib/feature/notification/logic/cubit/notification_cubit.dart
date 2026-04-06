import 'package:gym_management_app/feature/notification/data/model/notification_model.dart';
import 'package:gym_management_app/feature/notification/logic/cubit/notification_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCubit extends Cubit<NotificationStates> {
  NotificationCubit() : super(NotificationInitial());

  Future<void> getNotifications() async {
    emit(NotificationLoading());

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      final notifications = _getMockNotifications();

      if (notifications.isEmpty) {
        emit(NotificationEmpty());
      } else {
        emit(NotificationLoaded(notifications));
      }
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> markAsRead(String notificationId) async {
    // TODO: Implement API call to mark as read
  }

  int get unreadCount {
    if (state is NotificationLoaded) {
      return (state as NotificationLoaded).notifications
          .where((n) => !n.isRead)
          .length;
    }
    return 0;
  }

  Future<void> markAllAsRead() async {
    // TODO: Implement API call to mark all as read
  }

  List<NotificationModel> _getMockNotifications() {
    return [
      NotificationModel(
        id: '1',
        title: 'مرحباً بك في التطبيق',
        body: 'شكراً لاستخدامك تطبيق المعمورة للحضور والانصراف',
        time: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
        type: NotificationType.general,
      ),
      NotificationModel(
        id: '2',
        title: 'تم تسجيل حضورك بنجاح',
        body: 'تم تسجيل حضورك اليوم الساعة 9:00 صباحاً',
        time: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
        type: NotificationType.attendance,
      ),
      NotificationModel(
        id: '3',
        title: 'تذكير بتسجيل الانصراف',
        body: 'لا تنسى تسجيل انصرافك قبل مغادرة العمل',
        time: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
        type: NotificationType.reminder,
      ),
    ];
  }
}
