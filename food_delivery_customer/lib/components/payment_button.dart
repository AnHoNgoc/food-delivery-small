import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentButton extends StatelessWidget {
  final String text;
  final String assetIconPath;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PaymentButton({
    super.key,
    this.text = "",
    this.assetIconPath = "",
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 60.h),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: isLoading
          ? SizedBox(
        width: 24.w,
        height: 24.h,
        child: CircularProgressIndicator(
          color: Colors.blue,
          strokeWidth: 2,
        ),
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (assetIconPath.isNotEmpty) ...[
            Image.asset(assetIconPath, width: 100.w, height: 60.h),
            SizedBox(width: 10.w),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 18.sp,
              color: Theme.of(context).colorScheme.inversePrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}