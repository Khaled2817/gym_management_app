import 'package:gym_management_app/core/helpers/text_helper.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';
import 'package:gym_management_app/feature/attendance/logic/cubit/attendance_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendanceButtonsWidget extends StatelessWidget {
  const AttendanceButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildActionButton(
          context: context,
          label: TextManager.checkIn,
          icon: Icons.login,
          color: AppColorManager.primaryColor,
          onPressed: () => context.read<AttendanceCubit>().checkIn(),
        ),
        SizedBox(height: 16.h),
        _buildActionButton(
          context: context,
          label: TextManager.checkOut,
          icon: Icons.logout,
          color: AppColorManager.secondaryColor,
          onPressed: () => context.read<AttendanceCubit>().checkOut(),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 24.w),
        label: Text(
          label.tr(),
          style: TextStyleManager.font16BoldWhite(context),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }
}
