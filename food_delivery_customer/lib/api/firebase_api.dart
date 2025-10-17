import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../services/notification_service.dart';

class FirebaseApi {
  FirebaseApi._internal(); // private constructor
  static final FirebaseApi instance = FirebaseApi._internal();

  final _firebaseMessaging = FirebaseMessaging.instance;
  String? _fcmToken;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

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
  }

  String? get fcmToken => _fcmToken;
}