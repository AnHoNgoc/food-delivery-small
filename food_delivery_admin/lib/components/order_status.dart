import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/customer_order.dart';

class OrderStatusIndicator extends StatelessWidget {
  final OrderStatus status;
  final Function(OrderStatus) onStatusTap; // callback khi nhấn step

  OrderStatusIndicator({
    super.key,
    required this.status,
    required this.onStatusTap,
  });

  int _statusIndex(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.confirmed:
        return 1;
      case OrderStatus.delivering:
        return 2;
      case OrderStatus.completed:
        return 3;
      case OrderStatus.cancelled:
        return 4;
    }
  }

  final List<OrderStatus> stepsEnum = [
    OrderStatus.pending,
    OrderStatus.confirmed,
    OrderStatus.delivering,
    OrderStatus.completed,
  ];

  final List<String> stepsLabel = [
    "Pending",
    "Confirmed",
    "Delivering",
    "Completed",
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = _statusIndex(status);

    return Column(
      children: [
        // Circles + connectors
        Padding(
          padding: EdgeInsets.only(left: 15.w, right: 15.w),
          child: Row(
            children: List.generate(stepsLabel.length * 2 - 1, (i) {
              if (i.isEven) {
                final index = i ~/ 2;
                final isActive = index <= currentIndex;

                return GestureDetector(
                  onTap: () {
                    if (index != currentIndex) {
                      onStatusTap(stepsEnum[index]);
                    }
                  },
                  child: CircleAvatar(
                    radius: 14.r,
                    backgroundColor: isActive ? Colors.green : Colors.grey.shade400,
                    child: Icon(
                      isActive ? Icons.check : Icons.circle,
                      size: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                );
              } else {
                final leftIndex = (i - 1) ~/ 2;
                final isActive = leftIndex < currentIndex;

                return Expanded(
                  child: Container(
                    height: 2.h,
                    color: isActive ? Colors.green : Colors.grey.shade400,
                  ),
                );
              }
            }),
          ),
        ),
        SizedBox(height: 6.h),
        // Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(stepsLabel.length, (index) {
            final isActive = index <= currentIndex;
            return SizedBox(
              width: 64.w + (index < stepsLabel.length - 1 ? 2.w : 0),
              child: Center(
                child: Text(
                  stepsLabel[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? Colors.green : Colors.grey,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}