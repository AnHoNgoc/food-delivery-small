import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:app_links/app_links.dart';
import '../main.dart';
import '../provider/order_provider.dart';
import '../services/paypal_service.dart';
import '../routes/app_routes.dart';
import 'package:provider/provider.dart';

class DeepLinkHandler {

  final AppLinks _appLinks = AppLinks();
  final PayPalService _payPalService = PayPalService();
  bool _isHandling = false;

  /// Khởi tạo deep link handler
  Future<void> init() async {
    try {
      // Bắt link khi app cold start
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleUri(initialUri);
      }

      // Bắt link khi app đang chạy
      _appLinks.uriLinkStream.listen((uri) {
        _handleUri(uri);
      });
    } catch (e) {
      debugPrint('[PayPalDeepLinkHandler] Error init: $e');
    }
  }

  void _handleUri(Uri uri) async {
    if (_isHandling) return;
    _isHandling = true;

    final host = uri.host; // ví dụ: checkout-success, checkout-cancel
    final queryParams = uri.queryParameters;
    final orderId = queryParams['token']; // PayPal trả về orderId qua query param 'token'
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      switch (host) {
        case 'checkout-success':
          if (orderId != null) {
            try {
              await _payPalService.capturePayPalOrder(orderId);

              // 🔹 Sau khi capture thành công, tạo order thật
              final orderProvider = navigatorKey.currentContext?.read<OrderProvider>();
              await orderProvider?.createOrder();

              navigatorKey.currentState?.pushNamed(AppRoutes.orderSuccess);
            } catch (e) {
              navigatorKey.currentState?.pushNamed(AppRoutes.home);
            }
          } else {
            navigatorKey.currentState?.pushNamed(AppRoutes.home);
          }
          break;

        case 'checkout-cancel':
          navigatorKey.currentState?.pushNamed(AppRoutes.home);
          break;

        default:
          debugPrint('[PayPalDeepLinkHandler] Unknown host: $host');
      }
      _isHandling = false;
    });
  }
}