import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../components/my_description_box.dart';
import '../components/my_drawer.dart';
import '../components/my_food_tile.dart';
import '../components/my_sliver_app_bar.dart';
import '../components/my_tab_bar.dart';
import '../models/food.dart';
import '../services/food_service.dart';
import 'food_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FoodService _foodService = FoodService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: FoodCategory.values.length, vsync: this);
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
      padding: EdgeInsets.all(12.w),
      itemCount: categoryMenu.length,
      itemBuilder: (context, index) {
        final food = categoryMenu[index];
        return MyFoodTile(
          food: food,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FoodPage(food: food)),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          MySliverAppBar(
            title: MyTabBar(tabController: _tabController),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyDescriptionBox(),
                SizedBox(height: 80.h),
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