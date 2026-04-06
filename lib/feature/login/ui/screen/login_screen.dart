import 'package:gym_management_app/core/helpers/asset_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_management_app/core/helpers/spacing_helper.dart';
import 'package:gym_management_app/feature/login/ui/widget/email_and_password_feild.dart';
import 'package:gym_management_app/feature/login/ui/widget/login_button_widegt.dart';
import 'package:gym_management_app/feature/login/ui/widget/login_listener.dart';
import 'package:gym_management_app/feature/login/ui/widget/remember_me_and_forget_pass.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Image.asset(AssetHelper.logo, height: 250.h, width: 250.w),
                EmailAndPassword(),
                verticalSpace(5),
                RememberMeAndForgetPass(),
                verticalSpace(15),
                LoginButtonWidegt(),
                verticalSpace(15),
                LoginBlocListener(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
