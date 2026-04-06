import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_management_app/core/helpers/functions.dart';
import 'package:gym_management_app/core/helpers/spacing_helper.dart';
import 'package:gym_management_app/core/helpers/text_helper.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';
import 'package:gym_management_app/core/widgets/app_reactive_form.dart';
import 'package:gym_management_app/feature/login/logic/cubit/login_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EmailAndPassword extends StatefulWidget {
  const EmailAndPassword({super.key});

  @override
  State<EmailAndPassword> createState() => _EmailAndPasswordState();
}

class _EmailAndPasswordState extends State<EmailAndPassword> {
  bool isObscureText = true;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark
        ? AppColorManagerDark.primaryColor
        : AppColorManager.primaryColor;
    final inActiveColor = isDark
        ? AppColorManagerDark.lighterGray
        : AppColorManager.lighterGray;
    final fillColor = isDark
        ? AppColorManagerDark.backGroundFeildColor
        : AppColorManager.backGroundFeildColor;

    return ReactiveForm(
      formGroup: cubit.form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Login Type Toggle
          Center(
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: ValueListenableBuilder<LoginType>(
                valueListenable: cubit.loginType,
                builder: (context, loginType, child) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildToggleButton(
                        context: context,
                        label: TextManager.email.tr(),
                        isSelected: loginType == LoginType.email,
                        onTap: () => cubit.toggleLoginType(LoginType.email),
                        primaryColor: primaryColor,
                        inActiveColor: inActiveColor,
                      ),
                      horizontalSpace(8),
                      _buildToggleButton(
                        context: context,
                        label: TextManager.mobile.tr(),
                        isSelected: loginType == LoginType.phone,
                        onTap: () => cubit.toggleLoginType(LoginType.phone),
                        primaryColor: primaryColor,
                        inActiveColor: inActiveColor,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          verticalSpace(20),

          // Email or Phone Field
          ValueListenableBuilder<LoginType>(
            valueListenable: cubit.loginType,
            builder: (context, loginType, child) {
              if (loginType == LoginType.phone) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      TextManager.phoneNumber.tr(),
                      style: TextStyleManager.font16SemiBold(context),
                    ),
                    verticalSpace(10),
                    Row(
                      children: [
                        // Country Code Fixed +20
                        Container(
                          height: 56.h,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: fillColor,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Center(
                            child: Text(
                              LoginCubit.countryCode,
                              style: TextStyleManager.font14Medium(context),
                            ),
                          ),
                        ),
                        horizontalSpace(8),
                        // Phone Number Field
                        Expanded(
                          child: AppReactiveTextFormField(
                            formControlName: 'phone',
                            hintText: "01xxxxxxxxx",
                            keyboardType: TextInputType.phone,
                            enabledBorderColor: Colors.transparent,
                            validationMessages: {
                              ValidationMessage.required: (_) =>
                                  TextManager.phoneRequired.tr(),
                              'invalidPhone': (_) =>
                                  TextManager.invalidPhone.tr(),
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      TextManager.email.tr(),
                      style: TextStyleManager.font16SemiBold(context),
                    ),
                    verticalSpace(10),
                    AppReactiveTextFormField(
                      enabledBorderColor: Colors.transparent,
                      hintText: "example@email.com",
                      formControlName: 'email',
                      keyboardType: TextInputType.emailAddress,
                      validationMessages: validationEmailMessages(),
                    ),
                  ],
                );
              }
            },
          ),
          verticalSpace(20),

          // Password Field
          Text(
            TextManager.password.tr(),
            style: TextStyleManager.font16SemiBold(context),
          ),
          verticalSpace(10),
          AppReactiveTextFormField(
            formControlName: 'password',
            isObscureText: isObscureText,
            enabledBorderColor: Colors.transparent,
            hintText: "********",
            suffixIcon: GestureDetector(
              child: Icon(
                isObscureText ? Icons.visibility_off : Icons.visibility,
                size: 20.w,
                color: primaryColor,
              ),
              onTap: () {
                setState(() {
                  isObscureText = !isObscureText;
                });
              },
            ),
            validationMessages: validationPasswordMessages(),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color primaryColor,
    required Color inActiveColor,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: primaryColor.withValues(alpha: 0.3),
        highlightColor: primaryColor.withValues(alpha: 0.1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            label,
            style: isSelected
                ? TextStyleManager.font14Medium(
                    context,
                  ).copyWith(color: Colors.white)
                : TextStyleManager.font14Medium(
                    context,
                  ).copyWith(color: AppColorManager.primaryColor),
          ),
        ),
      ),
    );
  }
}
