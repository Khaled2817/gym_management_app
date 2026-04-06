import 'package:gym_management_app/core/helpers/text_helper.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';
import 'package:gym_management_app/feature/attendance/logic/cubit/statistics_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatisticsErrorCardWidget extends StatelessWidget {
  final String? error;

  const StatisticsErrorCardWidget({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColorManager.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Icon(Icons.bar_chart, size: 48.w, color: AppColorManager.gray),
          SizedBox(height: 12.h),
          Text(
            error ?? TextManager.statisticsLoadError.tr(),
            style: TextStyleManager.font14Medium(context),
          ),
          SizedBox(height: 12.h),
          TextButton(
            onPressed: () =>
                context.read<StatisticsCubit>().getMonthlyStatistics(),
            child: Text(
              TextManager.retry.tr(),
              style: TextStyleManager.font14Medium(
                context,
              ).copyWith(color: AppColorManager.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
