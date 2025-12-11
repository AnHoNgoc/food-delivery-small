import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyDescriptionBox extends StatelessWidget {
  const MyDescriptionBox({super.key});

  @override
  Widget build(BuildContext context) {
    var myPrimaryTextStyle = TextStyle(
      color: Theme.of(context).colorScheme.inversePrimary,
      fontSize: 14.sp, // responsive font
    );

    var mySecondaryTextStyle = TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 12.sp, // responsive font
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.secondary),
          borderRadius: BorderRadius.circular(8.r), // responsive radius
        ),
        padding: EdgeInsets.all(25.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text("\$0.5", style: myPrimaryTextStyle),
                Text("Delivery fee", style: mySecondaryTextStyle),
              ],
            ),
            Column(
              children: [
                Text("5-15 min", style: myPrimaryTextStyle),
                Text("Delivery time", style: mySecondaryTextStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}