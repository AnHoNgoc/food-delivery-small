import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../utils/confirmation_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void _logout(BuildContext context) async {
    final confirm = await showConfirmationDialog(
      context,
      title: "Logout",
      message: "Are you sure you want to logout?",
      confirmText: "Logout",
      cancelText: "Cancel",
    );

    if (confirm == true) {
      final _auth = AuthService();
      await _auth.logout();
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.message,
                    color: Theme.of(context).colorScheme.primary,
                    size: 48.sp, // responsive icon
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25.w),
                child: ListTile(
                  title: Text(
                    "H O M E",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  leading: Icon(Icons.home, size: 22.sp),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25.w),
                child: ListTile(
                  title: Text(
                    "S E T T I N G S",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  leading: Icon(Icons.settings, size: 22.sp),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.setting);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25.w),
                child: ListTile(
                  title: Text(
                    "P A S S W O R D",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  leading: Icon(Icons.password, size: 22.sp),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.changePassword);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25.w),
                child: ListTile(
                  title: Text(
                    "O R D E R S",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  leading: Icon(Icons.list, size: 22.sp),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.order);
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 25.w, bottom: 25.h),
            child: ListTile(
              title: Text(
                "L O G O U T",
                style: TextStyle(fontSize: 16.sp),
              ),
              leading: Icon(Icons.logout, size: 22.sp),
              onTap: () => _logout(context),
            ),
          ),
        ],
      ),
    );
  }
}