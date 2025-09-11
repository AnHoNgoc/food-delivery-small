import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/food.dart';

class FoodService {

  final CollectionReference _foodCollection =
  FirebaseFirestore.instance.collection('foods');

  /// Thêm 1 món ăn vào Firestore
  Future<void> addFood(Food food) async {
    try {
      await _foodCollection.doc(food.id).set({
        'id': food.id,
        'name': food.name,
        'description': food.description,
        'imagePath': food.imagePath,
        'price': food.price,
        'category': food.category.name, // enum -> string
        'availableAddons': food.availableAddons
            .map((addon) => {
          'name': addon.name,
          'price': addon.price,
        })
            .toList(),
      });
    } catch (e) {
      print('Error adding food: $e');
    }
  }

  /// Thêm nhiều món (vd: toàn bộ _menu)
  Future<void> addFoods(List<Food> foods) async {
    for (var food in foods) {
      await addFood(food);
    }
  }

  /// Lấy danh sách tất cả món ăn
  Future<List<Food>> getFoods() async {
    try {
      QuerySnapshot snapshot = await _foodCollection.get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Food.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error fetching foods: $e');
      return [];
    }
  }

  /// Nếu muốn theo stream realtime
  Stream<List<Food>> getFoodsStream() {
    return _foodCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Food.fromJson(data);
      }).toList();
    });
  }
}