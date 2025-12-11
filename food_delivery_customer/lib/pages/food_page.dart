import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_customer/components/my_button.dart';
import 'package:food_delivery_customer/provider/cart_provider.dart';
import 'package:provider/provider.dart';
import '../models/food.dart';
import '../provider/auth_provider.dart';
import '../routes/app_routes.dart';
import '../utils/confirmation_dialog.dart';
import '../utils/show_snackbar.dart';

class FoodPage extends StatefulWidget {
  final Food food;
  final Map<Addon, bool> selectedAddons = {};

  FoodPage({super.key, required this.food}) {
    for (Addon addon in food.availableAddons) {
      selectedAddons[addon] = false;
    }
  }

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  bool isLoading = false;

  void addToCart(Food food, Map<Addon, bool> selectedAddons) async {
    final authProvider = context.read<AuthProvider>();

    // Nếu chưa login, show dialog và điều hướng
    if (!authProvider.isLoggedIn) {
      final confirm = await showConfirmationDialog(
        context,
        title: "Login Required",
        message: "You must be logged in to add items to the cart.",
        confirmText: "Login",
        cancelText: "Cancel",
      );

      if (confirm == true) {
        Navigator.pushNamed(context, AppRoutes.login);
      }
      return;
    }

    // Nếu đã login → bình thường
    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 1));

    List<Addon> currentlySelectedAddons = [];
    for (Addon addon in food.availableAddons) {
      if (selectedAddons[addon] == true) {
        currentlySelectedAddons.add(addon);
      }
    }

    final added = context.read<CartProvider>().addToCart(food, currentlySelectedAddons);

    setState(() => isLoading = false);
    if (!added) {
      showAppSnackBar(context, "This item is already in your cart.", Colors.red);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Ảnh món ăn
                SlideInDown(
                  duration: const Duration(milliseconds: 500),
                  child: SizedBox(
                    height: 350.h,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: widget.food.imagePath,
                      placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tên món
                      SlideInDown(
                        delay: const Duration(milliseconds: 100),
                        child: Text(
                          widget.food.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                          ),
                        ),
                      ),

                      // Giá
                      SlideInDown(
                        delay: const Duration(milliseconds: 200),
                        child: Text(
                          '\$${widget.food.price.toString()}',
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      // Mô tả
                      SlideInDown(
                        delay: const Duration(milliseconds: 300),
                        child: Text(
                          widget.food.description,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      // Divider
                      SlideInDown(
                        delay: const Duration(milliseconds: 400),
                        child: Divider(
                          color: Theme.of(context).colorScheme.secondary,
                          thickness: 1.h,
                        ),
                      ),

                      SizedBox(height: 10.h),

                      // Tiêu đề Addons
                      SlideInDown(
                        delay: const Duration(milliseconds: 500),
                        child: Text(
                          "Add-ons",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      // Danh sách addons
                      SlideInDown(
                        delay: const Duration(milliseconds: 600),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.food.availableAddons.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              Addon addon = widget.food.availableAddons[index];
                              return CheckboxListTile(
                                title: Text(
                                  addon.name,
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                                subtitle: Text(
                                  '\$${addon.price}',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                value: widget.selectedAddons[addon],
                                onChanged: (bool? value) {
                                  setState(() {
                                    widget.selectedAddons[addon] = value!;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Nút Add to cart
                      SlideInDown(
                        delay: const Duration(milliseconds: 700),
                        child: MyButton(
                          text: "Add to cart",
                          isLoading: isLoading,
                          onTap: () => addToCart(widget.food, widget.selectedAddons),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25.h),
              ],
            ),
          ),
        ),

        // Nút Back
        SafeArea(
          child: SlideInDown(
            duration: const Duration(milliseconds: 300),
            child: Opacity(
              opacity: 0.6,
              child: Container(
                margin: EdgeInsets.only(left: 25.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
