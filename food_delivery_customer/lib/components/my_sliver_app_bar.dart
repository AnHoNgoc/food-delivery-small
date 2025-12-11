import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../provider/cart_provider.dart';
import '../routes/app_routes.dart';

class MySliverAppBar extends StatelessWidget {
  final Widget child;
  final Widget title;

  const MySliverAppBar({
    super.key,
    required this.child,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 340.h,
      collapsedHeight: 120.h,
      floating: false,
      pinned: true,
      centerTitle: true,
      actions: [
        Consumer<AuthProvider>(
          builder: (context, auth, child) {
            final isLoggedIn = auth.isLoggedIn;

            if (isLoggedIn) {
              // Nếu login rồi: hiển thị giỏ hàng
              return Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  int itemCount = cartProvider.getTotalItemCount();

                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.cart);
                      },
                      icon: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(Icons.shopping_cart, size: 28.sp),
                          if (itemCount > 0)
                            Positioned(
                              right: -6.w,
                              top: -10.h,
                              child: Container(
                                padding: EdgeInsets.all(2.sp),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 18.w,
                                  minHeight: 18.h,
                                ),
                                child: Text(
                                  '$itemCount',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              // Nếu chưa login: hiển thị icon login
              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.login);
                  },
                  icon: Icon(Icons.login, size: 28.sp),
                ),
              );
            }
          },
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text("Sunset Diner"),
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
