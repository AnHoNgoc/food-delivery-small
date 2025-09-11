import 'package:flutter/cupertino.dart';

import '../services/order_service.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService orderService;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  OrderProvider({required this.orderService});

  Future<void> createOrder() async {
    _isLoading = true;
    notifyListeners();

    try {
      await orderService.createOrder();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}