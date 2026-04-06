import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_management_app/core/helpers/asset_helper.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class PrettyQrCodeView extends StatelessWidget {
  final String data;
  final double size;

  const PrettyQrCodeView({Key? key, required this.data, this.size = 200})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: PrettyQr(
          data: data,
          size: size.w,
          roundEdges: true,
          image: AssetImage(AssetHelper.splash),
          elementColor: AppColorManager.black,
        ),
      ),
    );
  }
}
