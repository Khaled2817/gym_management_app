import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';
import 'package:gym_management_app/feature/attendance/data/model/attendance_record_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AttendanceRecordCardWidget extends StatelessWidget {
  final AttendanceRecordModel record;

  const AttendanceRecordCardWidget({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? AppColorManagerDark.cardBackground
        : AppColorManager.white;

    // Arabic date format
    final dateFormat = DateFormat.yMMMMEEEEd(context.locale.toString());
    final timeFormat = DateFormat.jm(context.locale.toString());

    final dateText = record.clockIn != null
        ? dateFormat.format(record.clockIn!)
        : '--';

    final clockInText = record.clockIn != null
        ? timeFormat.format(record.clockIn!)
        : '--:--';

    final clockOutText = record.clockOut != null
        ? timeFormat.format(record.clockOut!)
        : '--:--';

    final hasNotes =
        (record.clockInNote != null && record.clockInNote!.isNotEmpty) ||
        (record.clockOutNote != null && record.clockOutNote!.isNotEmpty);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header - Date and Status
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColorManager.primaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    dateText,
                    style: TextStyleManager.font14SemiBold(
                      context,
                    ).copyWith(color: AppColorManager.white),
                  ),
                ),
                _buildStatusChip(context),
              ],
            ),
          ),
          // Times Row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            child: Row(
              children: [
                // Check In
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.login_rounded,
                        size: 18.w,
                        color: AppColorManager.primaryColor,
                      ),
                      SizedBox(width: 6.w),
                      Column(
                        children: [
                          Text(
                            'الحضور',
                            style: TextStyleManager.font14SemiBold(context),
                          ),
                          Text(
                            clockInText,
                            style: TextStyleManager.font14SemiBold(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Divider
                Container(height: 40.h, width: 1, color: AppColorManager.gray),
                // Check Out
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        size: 18.w,
                        color: AppColorManager.red,
                      ),
                      SizedBox(width: 6.w),
                      Column(
                        children: [
                          Text(
                            'الانصراف',
                            style: TextStyleManager.font14SemiBold(
                              context,
                            ).copyWith(color: AppColorManager.red),
                          ),
                          Text(
                            clockOutText,
                            style: TextStyleManager.font14SemiBold(
                              context,
                            ).copyWith(color: AppColorManager.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Notes Section
          if (hasNotes)
            Container(
              padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 12.h),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColorManager.lighterGray.withValues(alpha: 0.5),
                  ),
                ),
              ),
              child: Column(
                children: [
                  if (record.clockInNote != null &&
                      record.clockInNote!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Row(
                        children: [
                          Icon(
                            Icons.note_alt_outlined,
                            size: 14.w,
                            color: AppColorManager.lightGray,
                          ),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              'ملاحظة: ${record.clockInNote}',
                              style: TextStyleManager.font12Medium(
                                context,
                              ).copyWith(color: AppColorManager.lightGray),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (record.clockOutNote != null &&
                      record.clockOutNote!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Row(
                        children: [
                          Icon(
                            Icons.note_alt_outlined,
                            size: 14.w,
                            color: AppColorManager.lightGray,
                          ),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              'ملاحظة: ${record.clockOutNote}',
                              style: TextStyleManager.font12Medium(
                                context,
                              ).copyWith(color: AppColorManager.lightGray),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color chipColor;
    Color textColor;
    String displayStatus;

    final stateValue = record.attendanceStateValue?.toLowerCase() ?? '';

    switch (stateValue) {
      case 'present':
      case 'حاضر':
        chipColor = AppColorManager.green;
        textColor = AppColorManager.green;
        displayStatus = 'حاضر';
        break;
      case 'absent':
      case 'غائب':
        chipColor = AppColorManager.red;
        textColor = AppColorManager.red;
        displayStatus = 'غائب';
        break;
      case 'late':
        chipColor = Colors.orange;
        textColor = Colors.orange;
        displayStatus = 'متأخر';
        break;
      default:
        chipColor = AppColorManager.lightGray;
        textColor = AppColorManager.lightGray;
        displayStatus = record.attendanceStateValue ?? '--';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        displayStatus,
        style: TextStyleManager.font12Medium(
          context,
        ).copyWith(color: textColor, fontWeight: FontWeight.w600),
      ),
    );
  }
}
