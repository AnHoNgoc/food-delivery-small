import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/food.dart';

class CartProvider extends ChangeNotifier {

  final List<CartItem> _cart = [];

  List<CartItem> get cart => _cart;

  static const String cartKey = "cart_data";

  CartProvider() {
    _loadCart();
  }

  bool addToCart(Food food, List<Addon> selectedAddons) {
    final normalizedAddons = selectedAddons;

    final exists = _cart.any(
          (item) =>
      item.food.id == food.id &&
          listEquals(item.selectedAddons, normalizedAddons),
    );

    if (!exists) {
      _cart.add(CartItem(food: food, selectedAddons: normalizedAddons));
      _saveCart();
      notifyListeners();
      return true;  // ✅ đã thêm
    } else {
      return false; // ❌ đã tồn tại
    }
  }

  // Xóa item
  void removeFromCart(CartItem cartItem) {
    _cart.remove(cartItem);
    _saveCart();
    notifyListeners();
  }

  // Tăng số lượng
  void increaseQuantity(CartItem cartItem) {
    int index = _cart.indexOf(cartItem);
    if (index != -1) {
      _cart[index].quantity++;
      _saveCart();
      notifyListeners();
    }
  }

  // Giảm số lượng
  void decreaseQuantity(CartItem cartItem) {
    int index = _cart.indexOf(cartItem);
    if (index != -1 && _cart[index].quantity > 1) {
      _cart[index].quantity--;
      _saveCart();
      notifyListeners();
    }
  }

  // Tính tổng giá
  double getTotalPrice() {
    double total = 0.0;
    for (CartItem cartItem in _cart) {
      double itemTotal = cartItem.food.price;
      for (Addon addon in cartItem.selectedAddons) {
        itemTotal += addon.price;
      }
      total += itemTotal * cartItem.quantity;
    }
    return total;
  }

  // Tính tổng số lượng item
  int getTotalItemCount() {
    return _cart.fold(0, (sum, item) => sum + item.quantity);
  }

  // Clear giỏ
  void clearCart() {
    _cart.clear();
    _saveCart();
    notifyListeners();
  }

  // ================== LƯU VÀ LOAD ==================

  Future<void> _saveCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartJson =
    _cart.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList(cartKey, cartJson);
  }

  Future<void> _loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartJson = prefs.getStringList(cartKey);

    if (cartJson != null) {
      _cart.clear();
      _cart.addAll(
          cartJson.map((jsonStr) => CartItem.fromJson(jsonDecode(jsonStr))));
      notifyListeners();
    }
  }
}