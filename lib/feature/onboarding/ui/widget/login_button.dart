import 'package:flutter/material.dart';
import 'package:gym_management_app/core/helpers/extentions.dart';
import 'package:gym_management_app/core/routing/routers.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';
import 'package:gym_management_app/core/widgets/app_text_button.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppTextButton(
      buttonText: 'البداية',
      textStyle: TextStyleManager.font16BoldWhite(context),
      onPressed: () {
        context.pushNamed(Routers.loginScreen);
      },
      backgroundGradient: AppColorManager.primaryLinearGradient,
    );
  }
}
