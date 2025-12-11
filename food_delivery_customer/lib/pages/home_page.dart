import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:food_delivery_customer/components/my_current_location.dart';
import 'package:food_delivery_customer/components/my_food_tile.dart';
import 'package:food_delivery_customer/components/my_sliver_app_bar.dart';
import 'package:food_delivery_customer/components/my_tab_bar.dart';
import 'package:food_delivery_customer/models/food.dart';
import 'package:food_delivery_customer/pages/food_page.dart';
import '../components/my_description_box.dart';
import '../components/my_drawer.dart';
import '../services/food_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FoodService _foodService = FoodService();

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: FoodCategory.values.length, vsync: this);
  }

  List<Food> _filterMenuCategory(FoodCategory category, List<Food> fullMenu) {
    return fullMenu.where((food) => food.category == category).toList();
  }

  Widget getFoodListView(List<Food> fullMenu, FoodCategory category) {
    final categoryMenu = _filterMenuCategory(category, fullMenu);

    if (categoryMenu.isEmpty) {
      return Center(child: Text("No items in this category."));
    }

    return ListView.builder(
      itemCount: categoryMenu.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final food = categoryMenu[index];
        return AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 300),
          child: SlideAnimation(
            verticalOffset: 50.0, // di n từ dưới lên
            child: FadeInAnimation(
              child: MyFoodTile(
                food: food,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => FoodPage(food: food)),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Builder(
        builder: (context) => MyDrawer(),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          MySliverAppBar(
            title: MyTabBar(tabController: _tabController),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Divider(
                  indent: 25.w,
                  endIndent: 25.w,
                  thickness: 1.h,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                MyCurrentLocation(),
                MyDescriptionBox(),
                SizedBox(height: 20.h)
              ],
            ),
          )
        ],
        body: StreamBuilder<List<Food>>(
          stream: _foodService.getFoodsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            final menu = snapshot.data ?? [];
            if (menu.isEmpty) {
              return Center(child: Text("No menu available."));
            }

            return TabBarView(
              controller: _tabController,
              children: FoodCategory.values
                  .map((category) => getFoodListView(menu, category))
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}
