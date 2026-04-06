import 'package:flutter/material.dart';
import 'package:gym_management_app/core/helpers/asset_helper.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/widgets/grediant_text.dart';

import '../../../../core/theming/styles.dart';

class PhoneImageAndText extends StatelessWidget {
  const PhoneImageAndText({super.key});

  @override
  Widget build(BuildContext context) {
    final overlayColor = Theme.of(context).scaffoldBackgroundColor;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [overlayColor, overlayColor.withOpacity(0.0)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: const [0.17, 0.5],
            ),
          ),
          child: Image.asset(AssetHelper.iphone),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: GradientText(
            'مَرْحَبًــا',
            textAlign: TextAlign.center,
            style: TextStyleManager.font32Bold(context).copyWith(height: 1.6),
            gradient: AppColorManager.primaryLinearGradient,
          ),
        ),
        Positioned(
          bottom: -30,
          left: 0,
          right: 0,
          child: GradientText(
            'بِكُمْ فِي المَعْمُورَةِ',
            textAlign: TextAlign.center,
            style: TextStyleManager.font36Bold(context).copyWith(height: 1.4),
            gradient: AppColorManager.secondLinearGradient,
          ),
        ),
      ],
    );
  }
}
