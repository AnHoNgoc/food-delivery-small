import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_customer/provider/cart_provider.dart';
import 'package:food_delivery_customer/provider/location_provider.dart';
import 'package:food_delivery_customer/utils/show_snackbar.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../components/my_button.dart';
import '../components/payment_button.dart';
import '../provider/order_provider.dart';
import '../routes/app_routes.dart';
import '../services/paypal_service.dart';


class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {

  final PayPalService _payPalService = PayPalService();

  bool isCodLoading = false;

  Future<void> _handleCodPayment() async {
    setState(() {
      isCodLoading = true;
    });

    try {
      await context.read<OrderProvider>().createOrder();
      if (mounted) {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, AppRoutes.orderSuccess);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        showAppSnackBar(context, "Failed to place order", Colors.redAccent);
      }
    } finally {
      if (mounted) {
        setState(() {
          isCodLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final restaurant = Provider.of<CartProvider>(context);
    final location = Provider.of<LocationProvider>(context);
    final cart = restaurant.cart;
    final totalAmount = restaurant.getTotalPrice();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: TextStyle(fontSize: 20.sp), // responsive font
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/payment.json',
              width: 250.sp,   // responsive size, giống Icon
              height: 250.sp,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20.h),
            // Danh sách món trong cart
            Expanded(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final item = cart[index];
                  return ListTile(
                    title: Text(item.food.name),
                    subtitle: Text(
                      "x${item.quantity}  •  \$${item.totalPrice.toStringAsFixed(2)}",
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Shipping Address 🚚 : ${location.currentAddress}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 16.sp, // responsive font size
                ),
                textAlign: TextAlign.left,
              ),
            ),

            // Tổng tiền
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 50.w), // dịch vào bên trái
                    child: Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 50.w), // dịch vào bên phải
                    child: Text(
                      '\$${restaurant.getTotalPrice().toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            MyButton(
              text: "Place Order",
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                  ),
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setModalState) {
                        return Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Choose Payment Method",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              // COD
                              PaymentButton(
                                assetIconPath: "assets/img/cod.png",
                                isLoading: isCodLoading,
                                onPressed: isCodLoading
                                    ? null
                                    : () async {
                                  setState(() => isCodLoading = true);
                                  setModalState(() {}); // rebuild bottom sheet
                                  await _handleCodPayment();
                                  setState(() => isCodLoading = false);
                                  setModalState(() {});
                                },
                              ),
                              SizedBox(height: 10.h),
                              // PayPal
                              PaymentButton(
                                assetIconPath: "assets/img/paypal.png",
                                onPressed: () {
                                  _payPalService.createPayPalOrder(totalAmount, 'USD');
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}