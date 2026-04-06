import 'package:gym_management_app/feature/login/logic/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';
import 'package:gym_management_app/core/widgets/app_text_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginButtonWidegt extends StatelessWidget {
  const LoginButtonWidegt({super.key});

  @override
  Widget build(BuildContext context) {
    return AppTextButton(
      buttonText: 'تسجيل الدخول',
      textStyle: TextStyleManager.font16BoldWhite(context),
      backgroundGradient: AppColorManager.primaryLinearGradient,
      onPressed: () {
        final cubit = context.read<LoginCubit>();
        if (cubit.isFormValid()) {
          cubit.emitLoginStates();
        } else {
          // Mark fields as touched to show validation errors
          cubit.form.markAllAsTouched();
        }
      },
    );
  }
}
