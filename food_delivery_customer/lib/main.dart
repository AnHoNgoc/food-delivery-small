import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_customer/provider/cart_provider.dart';
import 'package:food_delivery_customer/provider/location_provider.dart';
import 'package:food_delivery_customer/provider/order_provider.dart';
import 'package:food_delivery_customer/routes/app_routes.dart';
import 'package:food_delivery_customer/services/auth_service.dart';
import 'package:food_delivery_customer/services/order_service.dart';
import 'package:food_delivery_customer/themes/theme_provider.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        Provider(create: (_) => AuthService()), // 👈 thêm cái này

        ChangeNotifierProvider(
          create: (context) {
            final cartProvider = context.read<CartProvider>();
            final locationProvider = context.read<LocationProvider>();
            final authService = context.read<AuthService>(); // 👈 lấy từ Provider ở trên
            final orderService = OrderService(
              cartProvider: cartProvider,
              locationProvider: locationProvider,
              authService: authService,
            );
            return OrderProvider(orderService: orderService);
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // kích thước mockup (ví dụ iPhone 12)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: Provider.of<ThemeProvider>(context).themeData,
          initialRoute: AppRoutes.login,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}

