import 'cart_item.dart';

class CustomerOrder {
  final String id;
  final String userId;
  final List<CartItem> items;
  final String deliveryAddress;
  final double totalPrice;
  final DateTime createdAt;
  final OrderStatus status;

  CustomerOrder({
    required this.id,
    required this.userId,
    required this.items,
    required this.deliveryAddress,
    required this.totalPrice,
    required this.createdAt,
    this.status = OrderStatus.pending,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'items': items.map((item) => item.toJson()).toList(),
    'deliveryAddress': deliveryAddress,
    'totalPrice': totalPrice,
    'createdAt': createdAt.toIso8601String(),
    'status': status.name, // lưu enum dưới dạng string
  };

  factory CustomerOrder.fromJson(Map<String, dynamic> json) => CustomerOrder(
    id: json['id'],
    userId: json['userId'],
    items: (json['items'] as List)
        .map((item) => CartItem.fromJson(item))
        .toList(),
    deliveryAddress: json['deliveryAddress'],
    totalPrice: json['totalPrice'],
    createdAt: DateTime.parse(json['createdAt']),
    status: OrderStatus.values.firstWhere(
            (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending),
  );
}


enum OrderStatus {
  pending,
  confirmed,
  delivering,
  completed,
  cancelled,
}