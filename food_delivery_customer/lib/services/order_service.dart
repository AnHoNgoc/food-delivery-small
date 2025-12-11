import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/cart_item.dart';
import '../models/customer_order.dart';


class OrderService {
  final FirebaseFirestore firestore;

  OrderService({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  /// Tạo đơn hàng mới
  Future<void> createOrder({
    required String userId,
    required List<CartItem> items,
    required String deliveryAddress,
    required double totalPrice,
  }) async {
    if (items.isEmpty) {
      throw Exception("Cart is empty");
    }

    final order = CustomerOrder(
      id: const Uuid().v4(),
      userId: userId,
      items: List.from(items),
      deliveryAddress: deliveryAddress,
      totalPrice: totalPrice,
      createdAt: DateTime.now(),
    );

    await firestore.collection('orders').doc(order.id).set(order.toJson());
  }

  /// Lấy danh sách đơn hàng theo userId
  Future<List<CustomerOrder>> getOrdersByUser(String userId) async {
    final snapshot = await firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => CustomerOrder.fromJson(doc.data()))
        .toList();
  }
}