import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_customer/provider/auth_provider.dart';
import 'package:food_delivery_customer/provider/cart_provider.dart';
import 'package:food_delivery_customer/provider/location_provider.dart';
import 'package:food_delivery_customer/provider/order_provider.dart';
import 'package:food_delivery_customer/routes/app_routes.dart';
import 'package:food_delivery_customer/services/auth_service.dart';
import 'package:food_delivery_customer/services/notification_service.dart';
import 'package:food_delivery_customer/services/order_service.dart';
import 'package:food_delivery_customer/themes/theme_provider.dart';
import 'package:food_delivery_customer/utils/deeplink_handle.dart';
import 'package:provider/provider.dart';
import 'api/firebase_api.dart';
import 'firebase_options.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  await NotificationService.initialize();

  await FirebaseApi.instance.initNotifications();


  final deepLinkHandler = DeepLinkHandler();
  await deepLinkHandler.init();

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => AuthService()),
        Provider(create: (_) => OrderService()),

        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),

        ChangeNotifierProvider(
          create: (context) {
            final authService = context.read<AuthService>();
            return AuthProvider(service: authService);
          },
        ),


        ChangeNotifierProvider(
          create: (context) {
            final cartProvider = context.read<CartProvider>();
            final locationProvider = context.read<LocationProvider>();
            final authProvider = context.read<AuthProvider>();
            final orderService = context.read<OrderService>();

            return OrderProvider(
              orderService: orderService,
              cartProvider: cartProvider,
              locationProvider: locationProvider,
              authProvider: authProvider,
            );
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
          navigatorKey: navigatorKey,
          theme: Provider.of<ThemeProvider>(context).themeData,
          initialRoute: AppRoutes.splash,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}

