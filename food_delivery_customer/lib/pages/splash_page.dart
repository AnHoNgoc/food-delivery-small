import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Ảnh nền
          SizedBox.expand(
            child: Image.asset(
              'assets/img/splash.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Nút Get Started
          Positioned(
            bottom: 50.h, // dùng ScreenUtil
            left: 50.w,
            right: 50.w,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                backgroundColor: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
              child: Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                      (_) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}