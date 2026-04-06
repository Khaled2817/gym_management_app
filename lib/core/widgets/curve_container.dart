import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurvedHeaderBackground extends StatelessWidget {
  final Widget? child;
  final double height;

  const CurvedHeaderBackground({
    super.key,
    this.child,
    this.height = 260,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.h,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFFDBA14A),
            Color(0xFF295093),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36.r),
          bottomRight: Radius.circular(36.r),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -70.w,
            top: -20.h,
            child: Transform.rotate(
              angle: -0.45,
              child: Container(
                width: 220.w,
                height: 180.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFDBA14A).withOpacity(0.85),
                  borderRadius: BorderRadius.circular(45.r),
                ),
              ),
            ),
          ),

          Positioned(
            left: -20.w,
            top: 55.h,
            child: Transform.rotate(
              angle: -0.45,
              child: Container(
                width: 200.w,
                height: 120.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(40.r),
                ),
              ),
            ),
          ),

          Positioned(
            left: 60.w,
            top: 95.h,
            child: Container(
              width: 170.w,
              height: 70.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.10),
                borderRadius: BorderRadius.circular(50.r),
              ),
            ),
          ),

          Positioned(
            right: -35.w,
            top: -35.h,
            child: Container(
              width: 150.w,
              height: 150.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFDBA14A).withOpacity(0.12),
              ),
            ),
          ),

          Positioned(
            right: 40.w,
            top: 35.h,
            child: Container(
              width: 90.w,
              height: 90.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),

          if (child != null) child!,
        ],
      ),
    );
  }
}