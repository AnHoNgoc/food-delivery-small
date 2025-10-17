import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_delivery_admin/services/push_notification_service.dart';
import '../models/customer_order.dart';

class OrderService {

  final pushNotificationService = PushNotificationService();

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


  Future<bool> updateOrderAndNotify(
      String orderId,
      OrderStatus newStatus,
      String customerId,
      ) async {

    final success = await updateOrderStatus(orderId, newStatus);
    if (!success) return false;

    try {
      // Tuỳ nội dung thông báo theo trạng thái
      String title = 'Cập nhật đơn hàng 📦';
      String body = 'Trạng thái đơn hàng #$orderId đã được cập nhật: ${newStatus.name}.';

      // --- Debug: in ra các tham số ---
      print('🔹 Debug Push Notification Params:');
      print('customerId = "$customerId"');
      print('title = "$title"');
      print('body = "$body"');
      print('--------------------------------');

      await pushNotificationService.sendPushToCustomer(
        customerId: customerId,
        title: title,
        body: body,
      );
      print('✅ Đã gửi thông báo cập nhật đơn hàng.');
      return true;
    } catch (e) {
      print('⚠️ Lỗi khi gửi thông báo: $e');
      return true;
    }
  }


  Future<bool> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      await _orderCollection.doc(orderId).update({
        'status': newStatus.name,
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