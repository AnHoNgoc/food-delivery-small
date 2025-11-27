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

    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

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

    final fcm = FirebaseMessaging.instance;
    NotificationSettings settings = await fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // ✅ iOS FOREGROUND NOTIFICATION ENABLE
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  /// 🧭 Xử lý khi người dùng bấm vào thông báo
  static void handleNotificationClick() {
    navigatorKey.currentState?.pushNamed(AppRoutes.order);
  }

  /// 🔔 Hiển thị local notification khi app đang foreground
  static Future<void> showNotification(RemoteMessage message) async {
    // Android settings
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    // iOS settings
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true, // hiển thị alert
      presentBadge: true, // update badge
      presentSound: true, // play sound
    );

    // NotificationDetails hỗ trợ cả Android & iOS
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Hiển thị notification
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

    try {
      await _fireStore.collection('tokens').doc(token).set({
        'userId': user.uid,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print("✅ Saved FCM token for user ${user.uid}");
    } catch (e) {
      print('❗ Failed to save FCM token: $e');
    }
  }
}