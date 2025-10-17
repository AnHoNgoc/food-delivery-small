import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> saveFcmToken(String token) async {

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = _fireStore.collection('users').doc(user.uid);

    try {
      // 🔍 Tìm tất cả user đang giữ token này
      final query = await _fireStore
          .collection('users')
          .where('fcmToken', isEqualTo: token)
          .get();

      // ❌ Xóa token ở user cũ (nếu không phải user hiện tại)
      for (var doc in query.docs) {
        if (doc.id != user.uid) {
          await doc.reference.update({'fcmToken': FieldValue.delete()});
          print('🧹 Removed FCM token from old user: ${doc.id}');
        }
      }

      // 📋 Kiểm tra token hiện tại trong doc
      final snapshot = await docRef.get();
      final existingToken = snapshot.data()?['fcmToken'];

      if (existingToken == token) {
        print('ℹ️ FCM token unchanged — skip update.');
        return;
      }

      // ✅ Gán token mới cho user
      await docRef.set({'fcmToken': token}, SetOptions(merge: true));
      print('✅ FCM token assigned to user ${user.uid}');
    } catch (e) {
      print('❗ Failed to save/reassign FCM token: $e');
    }
  }
}