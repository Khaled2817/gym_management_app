import 'package:gym_management_app/core/helpers/text_helper.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';
import 'package:gym_management_app/feature/attendance/data/model/monthly_statistics_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MonthlyStatisticsWidget extends StatelessWidget {
  final MonthlyStatisticsModel statistics;

  const MonthlyStatisticsWidget({super.key, required this.statistics});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark
            ? AppColorManagerDark.cardBackground
            : AppColorManager.white,
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
          Text(
            TextManager.monthlyStatistics.tr(),
            style: TextStyleManager.font16SemiBold(context),
          ),
          // Legendر
          SizedBox(height: 12.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 8.h,
            children: [
              _buildLegendItem(
                context,
                AppColorManager.green,
                TextManager.attendanceDays.tr(),
                statistics.attendanceDays ?? 0,
              ),
              _buildLegendItem(
                context,
                Colors.orange,
                TextManager.lateDays.tr(),
                statistics.attendanceDaysWithLate ?? 0,
              ),
              _buildLegendItem(
                context,
                Colors.purple,
                TextManager.earlyDeparture.tr(),
                statistics.attendanceDaysWithEarlyDeparture ?? 0,
              ),
              _buildLegendItem(
                context,
                Colors.red,
                TextManager.absent.tr(),
                statistics.absentDays ?? 0,
              ),
              _buildLegendItem(
                context,
                AppColorManager.primaryColor,
                TextManager.holidays.tr(),
                statistics.holidays ?? 0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildLegendItem(
  BuildContext context,
  Color color,
  String label,
  int value,
) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6.w),
        Text('$label: $value', style: TextStyleManager.font12Medium(context)),
      ],
    ),
  );
}
