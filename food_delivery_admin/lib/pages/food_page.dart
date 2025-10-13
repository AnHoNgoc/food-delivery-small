import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../components/my_button.dart';
import '../models/food.dart';
import '../services/food_service.dart';
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
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 350.h,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: widget.food.imagePath,
                  placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.food.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    ),
                    Text(
                      '\$${widget.food.price.toString()}',
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      widget.food.description,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(height: 10.h),
                    Divider(
                      color: Theme.of(context).colorScheme.secondary,
                      thickness: 1.h,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Add-ons",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Theme.of(context)
                            .colorScheme
                            .inversePrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
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
                  ],
                ),
              ),
              MyButton(
                text: "Add to cart",
                onTap: () {},
              ),
              SizedBox(height: 25.h),
            ],
          ),
        ),
      ),

      // SafeArea chứa nút back và delete
      SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back
            Opacity(
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

            // Delete
            Opacity(
              opacity: 0.6,
              child: Container(
                margin: EdgeInsets.only(right: 25.w),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () async {
                    final confirmed = await showConfirmationDialog(
                      context,
                      title: "Delete Food",
                      message: "Are you sure you want to delete this food?",
                      confirmText: "Delete",
                      cancelText: "Cancel",
                    );

                    if (confirmed == true) {
                      try {
                        await FoodService().deleteFood(widget.food);
                        if (context.mounted) {
                          Navigator.pop(context); // quay lại màn trước
                          showAppSnackBar(
                            context,
                            "Food deleted successfully!",
                            Colors.green,
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          showAppSnackBar(
                            context,
                            "Failed to delete food: $e",
                            Colors.red,
                          );
                        }
                      }
                    }
                  },
                  icon: Icon(
                    Icons.delete,
                    size: 20.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}


