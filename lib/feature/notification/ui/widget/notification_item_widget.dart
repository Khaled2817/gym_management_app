import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';
import 'package:gym_management_app/core/widgets/app_text.dart';
import 'package:gym_management_app/feature/notification/data/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;

  const NotificationItemWidget({
    super.key,
    required this.notification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: notification.isRead
            ? (isDark ? AppColorManagerDark.cardBackground : Colors.white)
            : (isDark
                  ? AppColorManagerDark.cardBackground
                  : AppColorManager.secondaryColor.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark
              ? AppColorManagerDark.grey.withValues(alpha: 0.2)
              : AppColorManager.gray.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIcon(context, isDark),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AppText(
                              text: notification.title,
                              styleBuilder: (context) =>
                                  TextStyleManager.font14SemiBold(context),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!notification.isRead) ...[
                            SizedBox(width: 8.w),
                            Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: BoxDecoration(
                                color: AppColorManager.secondaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 4.h),
                      AppText(
                        text: notification.body,
                        styleBuilder: (context) =>
                            TextStyleManager.font12GrayRegular(context),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      AppText(
                        text: _formatTime(notification.time),
                        styleBuilder: (context) =>
                            TextStyleManager.font12GrayRegular(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, bool isDark) {
    Color iconColor;
    Color bgColor;
    IconData iconData;

    switch (notification.type) {
      case NotificationType.attendance:
        iconColor = AppColorManager.green;
        bgColor = AppColorManager.green.withValues(alpha: 0.1);
        iconData = Icons.check_circle_outline;
        break;
      case NotificationType.reminder:
        iconColor = const Color(0xFFFFA500);
        bgColor = const Color(0xFFFFA500).withValues(alpha: 0.1);
        iconData = Icons.access_time;
        break;
      case NotificationType.alert:
        iconColor = AppColorManager.red;
        bgColor = AppColorManager.red.withValues(alpha: 0.1);
        iconData = Icons.warning_amber_outlined;
        break;
      case NotificationType.general:
        iconColor = isDark
            ? AppColorManagerDark.primaryColor
            : AppColorManager.primaryColor;
        bgColor = isDark
            ? AppColorManagerDark.primaryColor.withValues(alpha: 0.1)
            : AppColorManager.primaryColor.withValues(alpha: 0.1);
        iconData = Icons.notifications_outlined;
    }

    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Icon(iconData, color: iconColor, size: 20.sp),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} دقيقة مضت';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ساعة مضت';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} يوم مضى';
    } else {
      return DateFormat('dd/MM/yyyy').format(time);
    }
  }
}
