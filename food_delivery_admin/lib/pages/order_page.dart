import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../components/order_status.dart';
import '../models/customer_order.dart';
import '../services/order_service.dart';
import '../utils/confirmation_dialog.dart';
import '../utils/show_snackbar.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int currentPage = 1;
  final int pageSize = 5;

  @override
  Widget build(BuildContext context) {
    final orderService = OrderService();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order List',
          style: TextStyle(fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<CustomerOrder>>(
        stream: orderService.getAllOrdersStream(),
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

          // 👉 phân trang
          final totalPages = (orders.length / pageSize).ceil();
          final startIndex = (currentPage - 1) * pageSize;
          final endIndex = (startIndex + pageSize).clamp(0, orders.length);
          final pageOrders = orders.sublist(startIndex, endIndex);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: pageOrders.length,
                  itemBuilder: (context, index) {
                    final order = pageOrders[index];
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
                            Text(
                              "Total: \$${order.totalPrice.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text("Items:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp)),
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
                                : OrderStatusIndicator(
                              status: order.status,
                              onStatusTap: (newStatus) async {
                                final confirm = await showConfirmationDialog(
                                  context,
                                  title: 'Update Order Status',
                                  message:
                                  'Are you sure you want to change status to ${newStatus.name}?',
                                  confirmText: 'Yes',
                                  cancelText: 'Cancel',
                                );

                                if (confirm == true) {
                                  final success = await orderService.updateOrderAndNotify(
                                    order.id,
                                    newStatus,
                                    order.userId
                                  );
                                  if (success) {
                                    showAppSnackBar(
                                        context, 'Order status updated successfully', Colors.green);
                                  } else {
                                    showAppSnackBar(
                                        context, 'Failed to update order status', Colors.redAccent);
                                  }
                                }
                              },
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // ❌ Nút Hủy (Cancel Order)
                                TextButton.icon(
                                  icon: const Icon(Icons.cancel, color: Colors.orange),
                                  label: const Text("Cancel"),
                                  onPressed: () async {
                                    final confirm = await showConfirmationDialog(
                                      context,
                                      title: 'Cancel Order',
                                      message: 'Are you sure you want to cancel this order?',
                                      confirmText: 'Yes',
                                      cancelText: 'No',
                                    );
                                    if (confirm == true) {
                                      final success = await orderService.updateOrderAndNotify(
                                        order.id,
                                        OrderStatus.cancelled,
                                        order.userId// 👈 enum canceled
                                      );
                                      if (success) {
                                        showAppSnackBar(context, 'Order canceled successfully', Colors.green);
                                      } else {
                                        showAppSnackBar(context, 'Failed to cancel order', Colors.redAccent);
                                      }
                                    }
                                  },
                                ),

                                // 🗑️ Nút Delete
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  tooltip: "Delete Order",
                                  onPressed: () async {
                                    final confirm = await showConfirmationDialog(
                                      context,
                                      title: 'Delete Order',
                                      message: 'Are you sure you want to delete this order permanently?',
                                      confirmText: 'Yes',
                                      cancelText: 'No',
                                    );
                                    if (confirm == true) {
                                      final success = await orderService.deleteOrderById(order.id);
                                      if (success) {
                                        showAppSnackBar(context, 'Order deleted successfully', Colors.green);
                                      } else {
                                        showAppSnackBar(context, 'Failed to delete order', Colors.redAccent);
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 👉 Thanh phân trang
              if (totalPages > 1)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Prev
                      IconButton(
                        icon: Icon(Icons.chevron_left, size: 18.sp),
                        onPressed: currentPage > 1
                            ? () => setState(() => currentPage--)
                            : null,
                      ),

                      ..._buildPageNumbersLight(currentPage, totalPages),

                      // Next
                      IconButton(
                        icon: Icon(Icons.chevron_right, size: 18.sp),
                        onPressed: currentPage < totalPages
                            ? () => setState(() => currentPage++)
                            : null,
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildPageNumbersLight(int currentPage, int totalPages) {
    const visibleRange = 2;
    final startPage = (currentPage - visibleRange).clamp(1, totalPages);
    final endPage = (currentPage + visibleRange).clamp(1, totalPages);

    List<Widget> pages = [];

    void addPage(int page) {
      final isActive = page == currentPage;
      pages.add(
        GestureDetector(
          onTap: () => setState(() => this.currentPage = page),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h), // 👉 tăng khoảng cách
            child: Text(
              "$page",
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.7)
              ),
            ),
          ),
        ),
      );
    }

    if (startPage > 1) {
      addPage(1);
      if (startPage > 2) {
        pages.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Text("...", style: TextStyle(fontSize: 14.sp)),
        ));
      }
    }

    for (int page = startPage; page <= endPage; page++) {
      addPage(page);
    }

    if (endPage < totalPages) {
      if (endPage < totalPages - 1) {
        pages.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Text("...", style: TextStyle(fontSize: 14.sp)),
        ));
      }
      addPage(totalPages);
    }

    return pages;
  }
}