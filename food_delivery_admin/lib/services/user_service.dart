import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getUserList() async {
    try {
      QuerySnapshot snapshot = await _fireStore.collection('users').get();

      List<Map<String, dynamic>> users = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).where((user) => user['role'] != 'admin').toList();

      return users;
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  Future<bool> deleteUserById(String userId) async {
    try {
      await _fireStore.collection('users').doc(userId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}