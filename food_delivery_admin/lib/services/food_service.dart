import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/food.dart';
import 'package:path/path.dart' as path;

class FoodService {

  final CollectionReference _foodCollection =
  FirebaseFirestore.instance.collection('foods');

  final _storage = FirebaseStorage.instance;

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


  /// Nếu muốn theo stream realtime
  Stream<List<Food>> getFoodsStream() {
    return _foodCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Food.fromJson(data);
      }).toList();
    });
  }

  // Upload ảnh lên Firebase Storage
  Future<String> uploadFoodImage(File file) async {
    try {
      final fileName =
          "${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}";
      final storageRef =
      FirebaseStorage.instance.ref().child("foods/$fileName");
      final uploadTask = await storageRef.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw Exception("Upload failed: $e");
    }
  }

  Future<void> deleteFood(Food food) async {
    try {
      // Xóa document trong Firestore
      await _foodCollection.doc(food.id).delete();

      // Nếu có ảnh trong storage thì xóa luôn
      if (food.imagePath.isNotEmpty) {
        final ref = _storage.refFromURL(food.imagePath);
        await ref.delete();
      }
    } catch (e) {
      throw Exception("Failed to delete food: $e");
    }
  }

}