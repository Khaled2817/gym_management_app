import 'package:gym_management_app/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_management_app/core/helpers/text_helper.dart';
import 'package:gym_management_app/core/widgets/app_text.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppTextWhiteMedium16(text: TextManager.employeesManagement),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 100.w,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 16.h),
            AppTextSemiBold16(text: TextManager.employeesScreen),
            SizedBox(height: 8.h),
            AppTextMedium16(text: TextManager.underDevelopment),
            // .build((context) => TextStyleManager.font14Medium(context).copyWith(
            //     color: Theme.of(context).disabledColor,
            //   )),
          ],
        ),
      ),
    );
  }
}
