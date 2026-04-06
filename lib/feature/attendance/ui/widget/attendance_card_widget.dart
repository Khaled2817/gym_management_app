import 'package:gym_management_app/core/helpers/date_time_helper.dart';
import 'package:gym_management_app/core/helpers/text_helper.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';
import 'package:gym_management_app/feature/attendance/data/model/current_attendance_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendanceCardWidget extends StatelessWidget {
  final CurrentAttendanceModel? attendance;

  const AttendanceCardWidget({super.key, this.attendance});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? AppColorManagerDark.cardBackground
        : AppColorManager.white;
    final clockInText = attendance?.clockIn == null
        ? "-- : --"
        : DateTimeHelper().timeToString(
            attendance?.clockIn ?? TimeOfDay(hour: 0, minute: 0),
          );

    final clockOutText = attendance?.clockOut == null
        ? "-- : --"
        : DateTimeHelper().timeToString(
            attendance?.clockOut ?? TimeOfDay(hour: 0, minute: 0),
          );
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                TextManager.todayAttendanceStatus.tr(),
                style: TextStyleManager.font16SemiBold(context),
              ),
              _buildStatusChip(
                context,
                attendance?.stateValue ?? TextManager.undefined.tr(),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Shift Info
          if (attendance?.shiftData != null) ...[
            _buildInfoRow(
              context,
              icon: Icons.work_outline,
              label: TextManager.shift.tr(),
              value: attendance!.shiftData!,
            ),
            SizedBox(height: 12.h),
          ],

          // Clock In & Clock Out
          Row(
            children: [
              Expanded(
                child: _buildTimeCard(
                  context,
                  icon: Icons.login,
                  label: TextManager.arrival.tr(),
                  time: clockInText,
                  isActive: attendance?.clockInWork ?? false,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildTimeCard(
                  context,
                  icon: Icons.logout,
                  label: TextManager.departure.tr(),
                  time: clockOutText,
                  isActive: attendance?.clockOutWork ?? false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    Color chipColor;
    String displayStatus;

    switch (status.toLowerCase()) {
      case 'present':
      case 'حاضر':
        chipColor = AppColorManager.green;
        displayStatus = TextManager.present.tr();
        break;
      case 'absent':
      case 'غائب':
        chipColor = AppColorManager.red;
        displayStatus = TextManager.absent.tr();
        break;
      case 'late':
      case 'متأخر':
        chipColor = Colors.orange;
        displayStatus = TextManager.late.tr();
        break;
      default:
        chipColor = AppColorManager.lightGray;
        displayStatus = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        displayStatus,
        style: TextStyleManager.font12Medium(
          context,
        ).copyWith(color: chipColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20.w, color: AppColorManager.primaryColor),
        SizedBox(width: 8.w),
        Text('$label: ', style: TextStyleManager.font14Medium(context)),
        Text(
          value,
          style: TextStyleManager.font14Medium(
            context,
          ).copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTimeCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String time,
    required bool isActive,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color:
            (isActive
                    ? AppColorManager.primaryColor
                    : AppColorManager.lighterGray)
                .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isActive
              ? AppColorManager.primaryColor
              : AppColorManager.lighterGray,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24.w,
            color: isActive
                ? AppColorManager.primaryColor
                : AppColorManager.lightGray,
          ),
          SizedBox(height: 8.h),
          Text(label, style: TextStyleManager.font14SemiBold(context)),
          SizedBox(height: 4.h),
          Text(
            time,
            style: TextStyleManager.font14SemiBold(context).copyWith(
              color: isActive
                  ? AppColorManager.primaryColor
                  : AppColorManager.lightGray,
            ),
          ),
        ],
      ),
    );
  }
}
