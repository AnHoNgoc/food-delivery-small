import 'package:flutter/cupertino.dart';
import 'package:food_delivery_customer/pages/cart_page.dart';
import 'package:food_delivery_customer/pages/change_password.dart';
import 'package:food_delivery_customer/pages/check_out_page.dart';
import 'package:food_delivery_customer/pages/home_page.dart';
import 'package:food_delivery_customer/pages/login_page.dart';
import 'package:food_delivery_customer/pages/order_page.dart';
import 'package:food_delivery_customer/pages/order_success_page.dart';
import 'package:food_delivery_customer/pages/register_page.dart';
import 'package:food_delivery_customer/pages/reset_password_page.dart';
import 'package:food_delivery_customer/pages/settings_page.dart';
import 'package:food_delivery_customer/pages/splash_page.dart';

class AppRoutes {

  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String cart = '/cart';
  static const String order = '/order';
  static const String changePassword = '/change-password';
  static const String checkout = '/checkout';
  static const String setting = '/setting';
  static const String orderSuccess = '/payment-success';
  static const String resetPassword = '/reset-password';
  static const String splash = '/splash';

  static Map<String, WidgetBuilder> get routes => {
    home: (context) => HomePage(),
    login: (context) => LoginPage(),
    cart: (context) => CartPage(),
    order: (context) => OrderPage(),
    register: (context) => RegisterPage(),
    changePassword: (context) => ChangePasswordPage(),
    checkout: (context) => CheckoutPage(),
    setting: (context) => SettingsPage(),
    orderSuccess: (context) => OrderSuccessPage(),
    resetPassword: (context) => ResetPasswordPage(),
    splash: (context) => SplashPage(),
  };
}