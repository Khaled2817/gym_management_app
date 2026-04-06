import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gym_management_app/core/theming/styles.dart';

/// ويدجت نص موحد تدعم الترجمة التلقائية
///
/// استخدام:
/// ```dart
/// AppText(
///   text: TextManager.settings,
///   styleBuilder: TextStyleManager.font16Bold,
/// )
/// ```
Widget AppText({
  required String text,
  required TextStyle Function(BuildContext) styleBuilder,
  TextAlign? textAlign,
  int? maxLines,
  TextOverflow? overflow,
  bool? softWrap,
}) {
  return Builder(
    builder: (context) {
      return Text(
        text.tr(),
        style: styleBuilder(context),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
      );
    },
  );
}

/// 🔹 Bold 16 - نص عريض 16
Widget AppTextBold16({
  required String text,
  TextAlign? textAlign,
  int? maxLines,
  TextOverflow? overflow,
}) {
  return Builder(
    builder: (context) => Text(
      text.tr(),
      style: TextStyleManager.font16Bold(context),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    ),
  );
}

/// 🔹 Bold 24 - نص عريض 24
Widget AppTextBold24({
  required String text,
  TextAlign? textAlign,
  int? maxLines,
  TextOverflow? overflow,
}) {
  return Builder(
    builder: (context) => Text(
      text.tr(),
      style: TextStyleManager.font24Bold(context),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    ),
  );
}

/// 🔹 SemiBold 16 - نص شبه عريض 16
Widget AppTextSemiBold16({
  required String text,
  TextAlign? textAlign,
  int? maxLines,
  TextOverflow? overflow,
}) {
  return Builder(
    builder: (context) => Text(
      text.tr(),
      style: TextStyleManager.font16SemiBold(context),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    ),
  );
}

/// 🔹 SemiBold 14 - نص شبه عريض 14
Widget AppTextSemiBold14({
  required String text,
  TextAlign? textAlign,
  int? maxLines,
  TextOverflow? overflow,
}) {
  return Builder(
    builder: (context) => Text(
      text.tr(),
      style: TextStyleManager.font14SemiBold(context),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    ),
  );
}

/// 🔹 Medium 16 - نص متوسط 16
Widget AppTextMedium16({
  required String text,
  TextAlign? textAlign,
  int? maxLines,
  TextOverflow? overflow,
}) {
  return Builder(
    builder: (context) => Text(
      text.tr(),
      style: TextStyleManager.font16Medium(context),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    ),
  );
}

/// 🔹 Gray SemiBold 16 - نص رمادي شبه عريض 16
Widget AppTextGraySemiBold16({
  required String text,
  TextAlign? textAlign,
  int? maxLines,
  TextOverflow? overflow,
}) {
  return Builder(
    builder: (context) => Text(
      text.tr(),
      style: TextStyleManager.font16GraySemiBold(context),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    ),
  );
}

/// 🔹 White SemiBold 16 - نص أبيض شبه عريض 16
Widget AppTextWhiteSemiBold16({
  required String text,
  TextAlign? textAlign,
  int? maxLines,
  TextOverflow? overflow,
}) {
  return Builder(
    builder: (context) => Text(
      text.tr(),
      style: TextStyleManager.font16WhiteSemiBold(context),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    ),
  );
}

/// 🔹 White Medium 16 - نص أبيض متوسط 16
Widget AppTextWhiteMedium16({
  required String text,
  TextAlign? textAlign,
  int? maxLines,
  TextOverflow? overflow,
}) {
  return Builder(
    builder: (context) => Text(
      text.tr(),
      style: TextStyleManager.font16WhiteMedium(context),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    ),
  );
}

/// 🔹 White Medium 18 - نص أبيض متوسط 18
Widget AppTextWhiteMedium18({
  required String text,
  TextAlign? textAlign,
  int? maxLines,
  TextOverflow? overflow,
}) {
  return Builder(
    builder: (context) => Text(
      text.tr(),
      style: TextStyleManager.font18WhiteMedium(context),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    ),
  );
}

/// 🔹 Primary SemiBold 16 - نص لون أساسي شبه عريض 16
Widget AppTextPrimarySemiBold16({
  required String text,
  TextAlign? textAlign,
  int? maxLines,
  TextOverflow? overflow,
}) {
  return Builder(
    builder: (context) => Text(
      text.tr(),
      style: TextStyleManager.font16DegradadoAzuSemiBold(context),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    ),
  );
}

/// 🔹 Bold 18 Dark - نص عريض داكن 18
Widget AppTextBold18Dark({
  required String text,
  TextAlign? textAlign,
  int? maxLines,
  TextOverflow? overflow,
}) {
  return Builder(
    builder: (context) => Text(
      text.tr(),
      style: TextStyleManager.font18DarkBlueBold(context),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    ),
  );
}

/// 🔹 Regular 12 Gray - نص عادي رمادي 12
Widget AppTextRegular12Gray({
  required String text,
  TextAlign? textAlign,
  int? maxLines,
  TextOverflow? overflow,
}) {
  return Builder(
    builder: (context) => Text(
      text.tr(),
      style: TextStyleManager.font12GrayRegular(context),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    ),
  );
}

/// 🔹 Regular 13 Gray - نص عادي رمادي 13
Widget AppTextRegular13Gray({
  required String text,
  TextAlign? textAlign,
  int? maxLines,
  TextOverflow? overflow,
}) {
  return Builder(
    builder: (context) => Text(
      text.tr(),
      style: TextStyleManager.font13GrayRegular(context),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    ),
  );
}
