import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PayPalService {

  final Uri createOrderUrl = Uri.parse("https://createorder-j4yhlolv6q-uc.a.run.app");
  final Uri captureOrderUrl = Uri.parse("https://captureorder-j4yhlolv6q-uc.a.run.app");

  Future<void> createPayPalOrder(double amount, String currency) async {
    print("DA GOI HAM CREATE ORDER");

    try {
      final response = await http.post(
        createOrderUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "amount": amount.toStringAsFixed(2),
          "currency": currency,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final approvalUrl = data['approvalUrl'];
        final orderId = data['orderId'];

        print("DA OK CREATE ORDER");

        if (approvalUrl != null) {
          final uri = Uri.parse(approvalUrl);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            throw "Could not launch PayPal URL";
          }
        }

        print("Order ID: $orderId");
      } else {
        print("Failed to create order: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> capturePayPalOrder(String orderId) async {
    try {
      final response = await http.post(
        captureOrderUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"orderId": orderId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Payment captured: $data");
      } else {
        print("Failed to capture order: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}