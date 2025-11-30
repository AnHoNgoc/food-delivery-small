import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_customer/provider/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery_customer/components/my_cart_tile.dart';

import '../components/my_button.dart';
import '../routes/app_routes.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final userCart = cartProvider.cart;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Your Cart',
              style: TextStyle(fontSize: 20.sp), // responsive font
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.delete_forever, size: 24.sp),
                onPressed: cartProvider.clearCart,
              ),
            ],
          ),
          body: userCart.isEmpty
              ? Center(
            child: Text(
              'Your cart is empty',
              style: TextStyle(fontSize: 16.sp),
            ),
          )
              : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: userCart.length,
                  itemBuilder: (context, index) {
                    final cartItem = userCart[index];
                    return FadeInLeft(
                      delay: Duration(milliseconds: 100 * index), // mỗi item delay khác nhau
                      child: MyCartTile(cartItem: cartItem),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.w),
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
                        '\$${cartProvider.getTotalPrice().toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.h,
                ),
                child: MyButton(
                  text: "Check Out",
                  onTap: (){
                    Navigator.pushNamed(context, AppRoutes.checkout);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


