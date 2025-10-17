import 'package:cloud_functions/cloud_functions.dart';

class PushNotificationService {
  // ✅ Khai báo instance với region khớp với Firebase function
  final FirebaseFunctions functions =
  FirebaseFunctions.instanceFor(region: 'us-central1');

  /// Gửi push notification đến customer
  Future<void> sendPushToCustomer({
    required String customerId,
    required String title,
    required String body,
    Map<String, String>? dataPayload,
  }) async {
    try {
      final Map<String, dynamic> payload = {
        'customerId': customerId,
        'title': title,
        'body': body,
        'dataPayload': dataPayload ?? {},
      };

      print('🔹 Sending push notification with payload: $payload');

      // ✅ Gọi đúng hàm onCall từ Cloud Function
      final callable = functions.httpsCallable('sendPushNotification');
      final result = await callable.call(payload);

      print('✅ Push notification sent successfully: ${result.data}');
    } on FirebaseFunctionsException catch (e) {
      print('🔥 Firebase Function error: ${e.message}');
      rethrow;
    } catch (e) {
      print('⚠️ Failed to send push notification: $e');
      rethrow;
    }
  }
}