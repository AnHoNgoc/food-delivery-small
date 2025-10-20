import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../services/notification_service.dart';

class FirebaseApi {

  FirebaseApi._internal(); // private constructor
  static final FirebaseApi instance = FirebaseApi._internal();

  final _firebaseMessaging = FirebaseMessaging.instance;
  String? _fcmToken;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      sound: true,
      provisional: false,
    );

    _fcmToken = await _firebaseMessaging.getToken();
    print('🔑 FCM Token: $_fcmToken');

    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      _fcmToken = newToken;
      print('🔄 FCM Token refreshed: $_fcmToken');

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await NotificationService().saveFcmToken(newToken);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationService.showNotification(message);
    });

    // Background (user bấm vào notification khi app đang ngầm)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      NotificationService.handleNotificationClick();
    });

    // Terminated (user bấm vào notification khi app tắt hẳn)
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        NotificationService.handleNotificationClick();
      }
    });

  }

  String? get fcmToken => _fcmToken;
}