import 'package:gym_management_app/core/helpers/roles.dart';
import 'package:gym_management_app/core/notifications/attendance_notification_service.dart';
import 'package:gym_management_app/core/routing/routers.dart';
import 'package:gym_management_app/core/widgets/app_show_dilog_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_management_app/core/helpers/extentions.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/feature/login/logic/cubit/login_cubit.dart';
import 'package:gym_management_app/feature/login/logic/cubit/login_states.dart';

class LoginBlocListener extends StatelessWidget {
  const LoginBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark
        ? AppColorManagerDark.primaryColor
        : AppColorManager.primaryColor;

    return BlocListener<LoginCubit, LoginStates>(
      listenWhen: (previous, current) =>
          current is Loading || current is Success || current is Error,
      listener: (context, state) {
        state.whenOrNull(
          loading: () {
            showDialog(
              context: context,
              builder: (context) =>
                  Center(child: CircularProgressIndicator(color: primaryColor)),
            );
          },
          success: (loginResponse) async {
            await _handleLoginSuccess(context, loginResponse.roles);
          },
          error: (error) {
            setupErrorState(context, error);
          },
        );
      },
      child: const SizedBox.shrink(),
    );
  }

  Future<void> _handleLoginSuccess(
    BuildContext context,
    List<String>? roles,
  ) async {
    context.pop();

    final hasAttendanceRole = roles?.contains(Roles.myAttendance) ?? false;
    final hasAdminRole = roles?.contains(Roles.admin) ?? false;

    if (hasAttendanceRole || hasAdminRole) {
      // Schedule local notifications for attendance users
      await AttendanceNotificationService.instance
          .scheduleAllAttendanceNotifications();
      // Navigate to main home with attendance features
      if (context.mounted) {
        context.pushReplacementNamed(Routers.mainHome);
      }
    } else {
      if (context.mounted) {
        showAppStatusDialog(
          context: context,
          title: 'غير متاح',
          message:
              'ليس لديك صلاحية الوصول إلى التطبيق. يرجى التواصل مع المسؤول.',
          type: AppDialogType.error,
          isError: true,
        );
      }
    }
  }

  void setupErrorState(BuildContext context, String error) {
    context.pop();
    showAppStatusDialog(
      context: context,
      title: 'Error',
      message: error,
      type: AppDialogType.error,
      isError: true,
    );
  }
}
