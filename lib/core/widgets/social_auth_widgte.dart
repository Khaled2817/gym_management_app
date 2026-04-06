import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gym_management_app/core/helpers/asset_helper.dart';
import 'package:gym_management_app/core/helpers/spacing_helper.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';

class SocialAuthWidgte extends StatelessWidget {
  final VoidCallback onTapGoogle;
  final VoidCallback onTapFacebook;
  final VoidCallback onTapApple;
  const SocialAuthWidgte({
    super.key,
    required this.onTapGoogle,
    required this.onTapFacebook,
    required this.onTapApple,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: 2,
              width: 100,
              color: Colors.grey.withOpacity(0.2),
            ),
            horizontalSpace(10),
            Text(
              'Or continue with',
              style: TextStyleManager.font15SemiBold(context),
            ),
            horizontalSpace(10),
            Container(
              height: 2,
              width: 100,
              color: Colors.grey.withOpacity(0.2),
            ),
          ],
        ),
        verticalSpace(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onTapFacebook,
              child: Container(
                padding: EdgeInsets.all(7.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColorManager.gray.withOpacity(0.1),
                ),
                child: SvgPicture.asset(AssetHelper.facebook, width: 32.w),
              ),
            ),
            horizontalSpace(20),
            GestureDetector(
              onTap: onTapGoogle,
              child: Container(
                padding: EdgeInsets.all(7.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColorManager.gray.withOpacity(0.1),
                ),
                child: SvgPicture.asset(AssetHelper.google, width: 32.w),
              ),
            ),
            horizontalSpace(20),
            GestureDetector(
              onTap: onTapApple,
              child: Container(
                padding: EdgeInsets.all(7.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColorManager.gray.withOpacity(0.1),
                ),
                child: Icon(Icons.apple, size: 32.w),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
