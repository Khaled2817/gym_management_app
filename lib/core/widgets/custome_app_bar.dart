import 'package:flutter/material.dart';
import 'package:gym_management_app/core/helpers/extentions.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';

PreferredSizeWidget customAppBar({
  Color? backgroundColor,
  double? elevation,
  IconThemeData? iconTheme,
  String? title,
  bool? centerTitle,
  Widget? leading,
  required BuildContext? context,
}) {
  final isDark = context != null
      ? Theme.of(context).brightness == Brightness.dark
      : false;
  final primaryColor = isDark
      ? AppColorManagerDark.primaryColor
      : AppColorManager.primaryColor;

  return AppBar(
    leading: GestureDetector(
      onTap: () {
        context?.pop();
      },
      child: leading ?? SizedBox(),
    ),
    backgroundColor: backgroundColor ?? primaryColor,
    title: Text(
      title ?? '',
      style: TextStyleManager.font24WhiteSemiBold(context!),
    ),
    centerTitle: centerTitle ?? true,
    elevation: elevation ?? 0,
    iconTheme: iconTheme ?? IconThemeData(color: Colors.white),
  );
}
