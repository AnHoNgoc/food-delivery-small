import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/customer_order.dart';
import '../provider/cart_provider.dart';
import '../provider/location_provider.dart';
import 'auth_service.dart';

class OrderService {
  final CartProvider cartProvider;
  final LocationProvider locationProvider;
  final AuthService authService;

  OrderService({
    required this.cartProvider,
    required this.locationProvider,
    required this.authService,
  });

  // Tạo đơn hàng mới
  Future<void> createOrder() async {
    final currentUser = authService.getCurrentUser();
    if (currentUser == null) {
      throw Exception("User not logged in");
    }

    if (cartProvider.cart.isEmpty) {
      throw Exception("Cart is empty");
    }

    final order = CustomerOrder(
      id: const Uuid().v4(),
      userId: currentUser.uid,
      items: List.from(cartProvider.cart),
      deliveryAddress: locationProvider.currentAddress,
      totalPrice: cartProvider.getTotalPrice(),
      createdAt: DateTime.now(),
    );

    await FirebaseFirestore.instance
        .collection('orders')
        .doc(order.id)
        .set(order.toJson());

    cartProvider.clearCart();
  }

  // Lấy đơn hàng theo userId
  Future<List<CustomerOrder>> getOrdersByUser() async {
    final currentUser = authService.getCurrentUser();
    if (currentUser == null) {
      throw Exception("User not logged in");
    }
    final snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: currentUser.uid)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => CustomerOrder.fromJson(doc.data()))
        .toList();
  }
}