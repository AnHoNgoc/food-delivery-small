import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/restaurant.dart';


class MySliverAppBar extends StatelessWidget {
  final Widget child;
  final Widget title;

  const MySliverAppBar({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300.h,
      collapsedHeight: 120.h,
      floating: false,
      pinned: true,
      centerTitle: true,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: IconButton(
            onPressed: () async {
              // final restaurant = Restaurant(); // hoặc lấy từ Provider nếu bạn dùng
              // await restaurant.uploadMenu();
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(content: Text("Menu uploaded to Firestore ✅")),
              // );
            },
            icon: Icon(
              Icons.add,
              size: 28.sp,
            ),
          ),
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text("Sunset Diner"),
      flexibleSpace: FlexibleSpaceBar(
        background: child,
        title: title,
        centerTitle: true,
        titlePadding: const EdgeInsets.only(left: 0, right: 0, top: 0),
        expandedTitleScale: 1,
      ),
    );
  }
}