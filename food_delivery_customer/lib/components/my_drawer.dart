import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../routes/app_routes.dart';
import '../utils/confirmation_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/password_dialog.dart';
import '../utils/show_snackbar.dart';

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
      final auth = context.read<AuthProvider>();
      await auth.logout();

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
            (_) => false,
      );
    }
  }

  void _goToLogin(BuildContext context) {
    Navigator.pop(context); // đóng drawer
    Navigator.pushNamed(context, AppRoutes.login);
  }

  Future<void> _handleDeleteAccount(BuildContext context) async {
    // 1️⃣ Hiển thị confirmation dialog
    final confirm = await showConfirmationDialog(
      context,
      title: "Delete Account",
      message: "Are you sure you want to delete your account? This action cannot be undone.",
      confirmText: "Delete",
      cancelText: "Cancel",
    );

    if (confirm != true) return; // user hủy

    // 2️⃣ Hiển thị dialog nhập mật khẩu
    final password = await PasswordDialog.show(context);
    if (password == null || password.isEmpty) return; // user hủy

    // 3️⃣ Gọi hàm xóa user từ AuthProvider
    final auth = context.read<AuthProvider>();
    final success = await auth.deleteCurrentUser(password: password);

    // 4️⃣ Xử lý kết quả
    if (success) {
      showAppSnackBar(
        context,
        "Account deleted successfully",
        Colors.green,
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
            (_) => false,
      );
    } else {
      showAppSnackBar(
        context,
        "Failed to delete account. Please try again.",
        Colors.redAccent,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isLoggedIn = auth.isLoggedIn;

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
                    size: 48.sp,
                  ),
                ),
              ),

              // Nếu đã login thì hiển thị Home
              if (isLoggedIn)
                Padding(
                  padding: EdgeInsets.only(left: 25.w),
                  child: ListTile(
                    title: Text("H O M E", style: TextStyle(fontSize: 16.sp)),
                    leading: Icon(Icons.home, size: 22.sp),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),

              // Settings luôn hiển thị
              Padding(
                padding: EdgeInsets.only(left: 25.w),
                child: ListTile(
                  title: Text("S E T T I N G S", style: TextStyle(fontSize: 16.sp)),
                  leading: Icon(Icons.settings, size: 22.sp),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.setting);
                  },
                ),
              ),

              // Nếu đã login hiển thị Password + Orders
              if (isLoggedIn) ...[
                Padding(
                  padding: EdgeInsets.only(left: 25.w),
                  child: ListTile(
                    title: Text("P A S S W O R D", style: TextStyle(fontSize: 16.sp)),
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
                      "D E L E T E\nA C C O U N T",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    leading: Icon(Icons.person, size: 22.sp),
                    onTap: () => _handleDeleteAccount(context),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.w),
                  child: ListTile(
                    title: Text("O R D E R S", style: TextStyle(fontSize: 16.sp)),
                    leading: Icon(Icons.list, size: 22.sp),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.order);
                    },
                  ),
                ),
              ],
            ],
          ),

          // Bottom ListTile: Logout nếu login, Login nếu chưa login
          Padding(
            padding: EdgeInsets.only(left: 25.w, bottom: 25.h),
            child: ListTile(
              title: Text(
                isLoggedIn ? "L O G O U T" : "L O G I N",
                style: TextStyle(fontSize: 16.sp),
              ),
              leading: Icon(
                isLoggedIn ? Icons.logout : Icons.login,
                size: 22.sp,
              ),
              onTap: () => isLoggedIn ? _logout(context) : _goToLogin(context),
            ),
          ),
        ],
      ),
    );
  }
}