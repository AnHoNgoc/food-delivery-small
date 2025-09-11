import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../components/my_button.dart';
import '../models/food.dart';

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
                height: 350.h, // dùng ScreenUtil để responsive
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: widget.food.imagePath,
                  placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
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
                        color: Theme.of(context).colorScheme.inversePrimary,
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
                onTap: () {}
              ),
              SizedBox(height: 25.h),
            ],
          ),
        ),
      ),
      SafeArea(
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
    ]);
  }
}

