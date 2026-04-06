import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum AppDialogType { success, error }

class AppStatusDialog extends StatelessWidget {
  const AppStatusDialog({
    super.key,
    required this.title,
    required this.message,
    required this.type,
    this.buttonText = 'تمام',
    this.onPressed,
  });

  final String title;
  final String message;
  final AppDialogType type;
  final String buttonText;
  final VoidCallback? onPressed;

  bool get isSuccess => type == AppDialogType.success;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSuccess
                    ? Colors.green.withValues(alpha: 0.12)
                    : Colors.red.withValues(alpha: 0.12),
              ),
              child: Icon(
                isSuccess ? Icons.check_rounded : Icons.close_rounded,
                size: 38.w,
                color: isSuccess ? Colors.green : Colors.red,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xff1E1E1E),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xff6B7280),
                height: 1.6,
              ),
            ),
            SizedBox(height: 22.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed ??
                    () {
                      Navigator.pop(context);
                    },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: isSuccess ? Colors.green : Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


Future<void> showAppStatusDialog({
  required BuildContext context,
  required String title,
  required String message,
  required AppDialogType type,
  String buttonText = 'تمام',
  VoidCallback? onPressed, required bool isError,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => AppStatusDialog(
      title: title,
      message: message,
      type: type,
      buttonText: buttonText,
      onPressed: onPressed,
    ),
  );
}