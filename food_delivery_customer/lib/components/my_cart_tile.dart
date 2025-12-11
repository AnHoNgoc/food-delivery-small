import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_customer/provider/cart_provider.dart';
import 'package:provider/provider.dart';
import '../models/cart_item.dart';


class MyCartTile extends StatelessWidget {
  final CartItem cartItem;

  const MyCartTile({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.read<CartProvider>();

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      color: Theme.of(context).colorScheme.secondary,
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row chính: ảnh + tên/giá + quantity + nút X
            Row(
              crossAxisAlignment: CrossAxisAlignment.start, // nút X căn trên
              children: [
                // Ảnh bo tròn
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: SizedBox(
                    width: 90.w,
                    height: 100.h,
                    child: CachedNetworkImage(
                      imageUrl: cartItem.food.imagePath,
                      placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),

                // Nội dung bên phải
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row tên + nút X
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Tên món
                                Text(
                                  cartItem.food.name,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 2.h),

                                // Category
                                Text(
                                  cartItem.food.category.name,
                                  style: TextStyle(fontSize: 14.sp),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          // Nút X
                          IconButton(
                            icon: Icon(Icons.close, size: 20.sp),
                            onPressed: () =>
                                cartProvider.removeFromCart(cartItem),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),

                      // Row giá + quantity
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${cartItem.totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove, size: 20.sp),
                                onPressed: () =>
                                    cartProvider.decreaseQuantity(cartItem),
                              ),
                              Text(
                                '${cartItem.quantity}',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                              IconButton(
                                icon: Icon(Icons.add, size: 20.sp),
                                onPressed: () =>
                                    cartProvider.increaseQuantity(cartItem),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),

            // Row Addons (nền xám, bo tròn)
            if (cartItem.selectedAddons.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: cartItem.selectedAddons.map((addon) {
                    return Container(
                      margin: EdgeInsets.only(right: 6.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Text(
                            addon.name,
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '\$${addon.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}