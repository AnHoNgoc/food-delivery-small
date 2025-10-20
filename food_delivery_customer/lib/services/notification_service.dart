import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';
import '../routes/app_routes.dart';

class NotificationService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  static final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  static const _channelId = 'high_importance_channel';
  static const _channelName = 'High Importance Notifications';
  static const _channelDescription = 'Used for important notifications.';

  /// 🚀 Khởi tạo local notification + tạo channel (Android)
  static Future<void> initialize() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();

    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          try {
            final data = jsonDecode(response.payload!);
            handleNotificationClick();
          } catch (e) {
            print('❌ Parse payload error: $e');
          }
        }
      },
    );

    // 🔔 Tạo notification channel cho Android 8.0+
    final android = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await android?.createNotificationChannel(AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
    ));
  }

  /// 🧭 Xử lý khi người dùng bấm vào thông báo
  static void handleNotificationClick() {
    navigatorKey.currentState?.pushNamed(AppRoutes.order);
  }

  /// 🔔 Hiển thị local notification khi app đang foreground
  static Future<void> showNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'Notification',
      message.notification?.body ?? '',
      notificationDetails,
      payload: jsonEncode(message.data),
    );
  }


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