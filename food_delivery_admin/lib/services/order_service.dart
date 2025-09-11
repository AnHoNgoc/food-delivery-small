import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/customer_order.dart';

class OrderService {

  final CollectionReference _orderCollection =
  FirebaseFirestore.instance.collection('orders');

  Stream<List<CustomerOrder>> getAllOrdersStream() {
    return _orderCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => CustomerOrder.fromJson({
      'id': doc.id,
      ...doc.data() as Map<String, dynamic>,
    }))
        .toList());
  }

  /// Cập nhật status của đơn hàng
  Future<bool> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      await _orderCollection.doc(orderId).update({
        'status': newStatus.name, // lưu enum dưới dạng string
      });
      return true;
    } catch (e) {
      print('Error updating order status: $e');
      return false;
    }
  }

  /// Xoá order theo id
  Future<bool> deleteOrderById(String orderId) async {
    try {
      await _orderCollection.doc(orderId).delete();
      return true;
    } catch (e) {
      print('Error deleting order: $e');
      return false;
    }
  }
}