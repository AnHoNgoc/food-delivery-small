import 'package:flutter/cupertino.dart';
import 'package:flutter_delivery_admin/pages/add_food_page.dart';
import 'package:flutter_delivery_admin/pages/user_page.dart';
import '../pages/change_password_page.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/order_page.dart';
import '../pages/register_page.dart';
import '../pages/settings_page.dart';

class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String order = '/order';
  static const String users = '/users';
  static const String changePassword = '/change-password';
  static const String setting = '/setting';
  static const String addProduct = '/add-product';

  static Map<String, WidgetBuilder> get routes => {
    home: (context) => HomePage(),
    login: (context) => LoginPage(),
    order: (context) => OrderPage(),
    users: (context) => UserPage(),
    register: (context) => RegisterPage(),
    changePassword: (context) => ChangePasswordPage(),
    setting: (context) => SettingsPage(),
    addProduct: (context) => AddFoodPage(),
  };
}