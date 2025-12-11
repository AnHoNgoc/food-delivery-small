import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../components/order_status.dart';
import '../models/customer_order.dart';
import '../provider/order_provider.dart';



class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: TextStyle(fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<CustomerOrder>>(
        future: orderProvider.fetchUserOrders(), // ✅ gọi từ provider
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return Center(
              child: Text(
                "No orders yet.",
                style: TextStyle(fontSize: 14.sp),
              ),
            );
          }


          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final createdAt =
              DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt);

              return Card(
                color: Theme.of(context).colorScheme.secondary,
                margin: EdgeInsets.all(12.w),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Order",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text("Created At: $createdAt",
                          style: TextStyle(fontSize: 12.sp)),
                      Text("Address: ${order.deliveryAddress}",
                          style: TextStyle(fontSize: 12.sp)),
                      SizedBox(height: 8.h),

                      Text("Total: \$${order.totalPrice.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.bold)),

                      SizedBox(height: 8.h),
                      Text("Items:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12.sp)),
                      ...order.items.map((item) => Padding(
                        padding: EdgeInsets.only(left: 8.w, top: 2.h),
                        child: Text(
                          "- ${item.food.name} x${item.quantity}",
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      )),
                      SizedBox(height: 12.h),
                      order.status == OrderStatus.cancelled
                          ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Text(
                          "This order has been canceled",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      )
                      : OrderStatusIndicator(status: order.status),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}