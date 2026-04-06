import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';
import 'package:gym_management_app/core/widgets/app_text.dart';
import 'package:gym_management_app/feature/notification/data/model/notification_model.dart';
import 'package:gym_management_app/feature/notification/logic/cubit/notification_cubit.dart';
import 'package:gym_management_app/feature/notification/logic/cubit/notification_states.dart';
import 'package:gym_management_app/feature/notification/ui/widget/notification_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => NotificationCubit()..getNotifications(),
      child: Scaffold(
        backgroundColor: isDark
            ? AppColorManagerDark.scaffoldBackground
            : Colors.white,
        appBar: AppBar(
          title: AppText(
            text: 'notifications',
            styleBuilder: (context) =>
                TextStyleManager.font18DarkDegradadoAzulBold(context),
          ),
          centerTitle: true,
          backgroundColor: isDark
              ? AppColorManagerDark.scaffoldBackground
              : Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: isDark
                  ? AppColorManagerDark.primaryColor
                  : AppColorManager.primaryColor,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const _NotificationBody(),
      ),
    );
  }
}

class _NotificationBody extends StatelessWidget {
  const _NotificationBody();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<NotificationCubit, NotificationStates>(
      builder: (context, state) {
        if (state is NotificationLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is NotificationLoaded) {
          return _NotificationsList(notifications: state.notifications);
        } else if (state is NotificationEmpty) {
          return _EmptyState(isDark: isDark);
        } else if (state is NotificationError) {
          return _ErrorState(isDark: isDark, error: state.error);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _NotificationsList extends StatelessWidget {
  final List<NotificationModel> notifications;

  const _NotificationsList({required this.notifications});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return NotificationItemWidget(
          notification: notifications[index],
          onTap: () {
            context.read<NotificationCubit>().markAsRead(
              notifications[index].id,
            );
          },
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDark;

  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 80.sp,
            color: isDark ? AppColorManagerDark.gray : AppColorManager.gray,
          ),
          SizedBox(height: 16.h),
          AppText(
            text: 'no_notifications',
            styleBuilder: (context) =>
                TextStyleManager.font16GrayMedium(context),
          ),
          SizedBox(height: 8.h),
          AppText(
            text: 'no_notifications_desc',
            styleBuilder: (context) =>
                TextStyleManager.font14GrayRegular(context),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final bool isDark;
  final String error;

  const _ErrorState({required this.isDark, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80.sp,
            color: isDark ? AppColorManagerDark.red : AppColorManager.red,
          ),
          SizedBox(height: 16.h),
          AppText(
            text: error,
            styleBuilder: (context) =>
                TextStyleManager.font14Medium(context).copyWith(
                  color: isDark ? AppColorManagerDark.red : AppColorManager.red,
                ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {
              context.read<NotificationCubit>().getNotifications();
            },
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}
