import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/customer_order.dart';


class OrderStatusIndicator extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusIndicator({super.key, required this.status});

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

  @override
  Widget build(BuildContext context) {
    final currentIndex = _statusIndex(status);
    final steps = [
      "Pending",
      "Confirmed",
      "Delivering",
      "Completed",
    ];

    return Column(
      children: [
        // Circles + connectors
        Padding(
          padding: EdgeInsets.only(left: 15.w  , right: 15.w),
          child: Row(
            children: List.generate(steps.length * 2 - 1, (i) {
              if (i.isEven) {
                final index = i ~/ 2;
                final isActive = index <= currentIndex;

                return CircleAvatar(
                  radius: 14.r, // responsive
                  backgroundColor: isActive
                      ? Colors.green
                      : Colors.grey.shade400,
                  child: Icon(
                    isActive ? Icons.check : Icons.circle,
                    size: 14.sp, // responsive
                    color: Colors.white,
                  ),
                );
              } else {
                final leftIndex = (i - 1) ~/ 2;
                final isActive = leftIndex < currentIndex;

                return Expanded(
                  child: Container(
                    height: 2.h, // responsive
                    color: isActive
                        ? Colors.green
                        : Colors.grey.shade400,
                  ),
                );
              }
            }),
          ),
        ),
        SizedBox(height: 6.h), // responsive spacing
        // Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(steps.length, (index) {
            final isActive = index <= currentIndex;
            return SizedBox(
              width: 64.w + (index < steps.length - 1 ? 2.w : 0),
              // 28.w là diameter của circle + padding, 2.w là width line connector, tùy chỉnh
              child: Center(
                child: Text(
                  steps[index],
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