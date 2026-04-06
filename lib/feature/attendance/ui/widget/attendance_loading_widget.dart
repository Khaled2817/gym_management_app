import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendanceLoadingWidget extends StatelessWidget {
  final String message;

  const AttendanceLoadingWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColorManager.primaryColor),
          SizedBox(height: 16.h),
          Text(message, style: TextStyleManager.font14Medium(context)),
        ],
      ),
    );
  }
}
