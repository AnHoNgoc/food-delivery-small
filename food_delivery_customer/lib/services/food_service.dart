import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/food.dart';

class FoodService {

  final CollectionReference _foodCollection =
  FirebaseFirestore.instance.collection('foods');

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