import 'package:gym_management_app/core/dependancies_injection/di.dart';
import 'package:gym_management_app/core/helpers/spacing_helper.dart';
import 'package:gym_management_app/core/helpers/text_helper.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/widgets/app_text.dart';
import 'package:gym_management_app/feature/attendance/data/repo/attendance_repo.dart';
import 'package:gym_management_app/feature/attendance/logic/cubit/attendance_cubit.dart';
import 'package:gym_management_app/feature/attendance/logic/cubit/attendance_states.dart';
import 'package:gym_management_app/feature/attendance/ui/widget/attendance_buttons_widget.dart';
import 'package:gym_management_app/feature/attendance/ui/widget/attendance_error_widget.dart';
import 'package:gym_management_app/feature/attendance/ui/widget/attendance_form_widget.dart';
import 'package:gym_management_app/feature/attendance/ui/widget/attendance_loading_widget.dart';
import 'package:gym_management_app/feature/attendance/ui/widget/attendance_success_widget.dart';
import 'package:gym_management_app/feature/attendance/ui/widget/current_time_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AttendanceCubit(getIt<AttendanceRepo>()),
      child: Scaffold(
        appBar: AppBar(
          title: AppTextWhiteMedium16(text: TextManager.attendanceRegistration),
          centerTitle: true,
        ),
        body: SafeArea(
          child: BlocConsumer<AttendanceCubit, AttendanceStates>(
            listener: (context, state) {
              if (state is AttendanceError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: AppColorManager.red,
                  ),
                );
              }
            },
            builder: (context, state) => _buildBody(state),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(AttendanceStates state) {
    if (state is AttendanceLoading || state is AttendanceLocationLoading) {
      return AttendanceLoadingWidget(
        message: state is AttendanceLocationLoading
            ? TextManager.gettingLocation.tr()
            : TextManager.registering.tr(),
      );
    }
    if (state is AttendanceSuccess)
      return AttendanceSuccessWidget(message: state.message);
    if (state is AttendanceError)
      return AttendanceErrorWidget(error: state.error);
    return const AttendanceInitialBody();
  }
}

class AttendanceInitialBody extends StatelessWidget {
  const AttendanceInitialBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // verticalSpace(50),
            Icon(
              Icons.access_time,
              size: 80.w,
              color: AppColorManager.primaryColor,
            ),
            SizedBox(height: 16.h),
            const CurrentTimeWidget(),
            SizedBox(height: 8.h),
            AppTextSemiBold16(
              text: TextManager.attendanceWelcome,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            const AttendanceFormWidget(),
            SizedBox(height: 32.h),
            const AttendanceButtonsWidget(),
          ],
        ),
      ),
    );
  }
}
