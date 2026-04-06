import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:gym_management_app/core/helpers/text_helper.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';
import 'package:gym_management_app/feature/login/logic/cubit/login_cubit.dart';
import 'package:easy_localization/easy_localization.dart';

class RememberMeAndForgetPass extends StatelessWidget {
  const RememberMeAndForgetPass({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();

    return Row(
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: cubit.rememberMe,
          builder: (context, value, child) {
            return Checkbox(
              value: value,
              onChanged: (v) => cubit.toggleRememberMe(v ?? true),
              activeColor: AppColorManager.primaryColor,
              checkColor: Colors.white,
              side: BorderSide(color: AppColorManager.lightGray, width: 1.5.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r),
              ),
            );
          },
        ),
        Text(
          TextManager.rememberMe.tr(),
          style: TextStyleManager.font13SemiBoldGary(context),
        ),
        const Spacer(),
      ],
    );
  }
}
