import 'package:flutter/cupertino.dart';
import '../models/customer_order.dart';
import '../services/order_service.dart';
import 'auth_provider.dart';
import 'cart_provider.dart';
import 'location_provider.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService orderService;
  final CartProvider cartProvider;
  final LocationProvider locationProvider;
  final AuthProvider authProvider;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  OrderProvider({
    required this.orderService,
    required this.cartProvider,
    required this.locationProvider,
    required this.authProvider,
  });

  Future<void> createOrder() async {
    final user = authProvider.user;
    if (user == null) throw Exception("User not logged in");

    _isLoading = true;
    notifyListeners();

    try {
      await orderService.createOrder(
        userId: user.uid,
        items: cartProvider.cart,
        deliveryAddress: locationProvider.currentAddress,
        totalPrice: cartProvider.getTotalPrice(),
      );
      cartProvider.clearCart();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<CustomerOrder>> fetchUserOrders() async {
    final user = authProvider.user;
    if (user == null) throw Exception("User not logged in");

    return await orderService.getOrdersByUser(user.uid);
  }
}