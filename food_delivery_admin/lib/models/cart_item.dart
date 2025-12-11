import 'food.dart';

class CartItem {
  final Food food;
  int quantity;
  List <Addon> selectedAddons;

  CartItem({
    this.quantity = 1,
    required this.food,
    required this.selectedAddons,
  });

  double get totalPrice {
    double addonPrice = selectedAddons.fold(0.0, (sum, addon)=> sum + addon.price);
    return (food.price + addonPrice) * quantity;
  }

  Map<String, dynamic> toJson() => {
    'food': food.toJson(),
    'selectedAddons': selectedAddons.map((a) => a.toJson()).toList(),
    'quantity': quantity,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    food: Food.fromJson(json['food']),
    selectedAddons: (json['selectedAddons'] as List)
        .map((a) => Addon.fromJson(a))
        .toList(),
    quantity: json['quantity'],
  );


}