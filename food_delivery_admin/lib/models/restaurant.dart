import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import '../services/food_service.dart';
import 'food.dart';

final uuid = Uuid();

class Restaurant extends ChangeNotifier {

  final List<Food> _menu = [
    // Burgers
    Food(
      id: uuid.v4(),
      name: "Classic Burger",
      description: "A traditional beef burger with cheese, fresh veggies, and special sauce.",
      imagePath: "https://recipes.zone/wp-content/uploads/2024/10/Classic-Homemade-Juicy-Burger.png",
      price: 5.99,
      category: FoodCategory.burgers,
      availableAddons: [
        Addon(name: "Extra Cheese", price: 1.00),
        Addon(name: "Extra Beef Patty", price: 2.50),
        Addon(name: "Extra Bacon", price: 1.75),
      ],
    ),
    Food(
      id: uuid.v4(),
      name: "Chicken Burger",
      description: "Crispy fried chicken burger with mayo and lettuce.",
      imagePath: "https://t3.ftcdn.net/jpg/07/17/41/56/360_F_717415618_SigHwZhkHxdAt04RwwYNIK6UlZ5d7CZj.jpg",
      price: 6.49,
      category: FoodCategory.burgers,
      availableAddons: [
        Addon(name: "Add Egg", price: 1.50),
        Addon(name: "Extra Chicken", price: 2.00),
      ],
    ),
    Food(
      id: uuid.v4(),
      name: "Veggie Burger",
      description: "Vegetarian burger with veggie patty and smoky BBQ sauce.",
      imagePath: "https://lifewithoutandy.com/wp-content/uploads/2020/01/Screen-Shot-2020-01-15-at-10.59.11-am.png",
      price: 5.49,
      category: FoodCategory.burgers,
      availableAddons: [
        Addon(name: "Add Avocado", price: 1.20),
        Addon(name: "Add Mushrooms", price: 1.00),
      ],
    ),
    Food(
      id: uuid.v4(),
      name: "Double Beef Burger",
      description: "Two beef patties, cheddar cheese, onions, and special sauce.",
      imagePath: "https://burgerrecipes.sfo3.digitaloceanspaces.com/wp-content/uploads/2025/07/25034939/Double-Whopper-Style-Burger.png",
      price: 8.99,
      category: FoodCategory.burgers,
      availableAddons: [
        Addon(name: "Extra Cheese", price: 1.00),
        Addon(name: "Add Bacon", price: 1.50),
      ],
    ),
    Food(
      id: uuid.v4(),
      name: "Spicy Burger",
      description: "Spicy burger with jalapeños, pepper jack cheese, and hot sauce.",
      imagePath: "https://st4.depositphotos.com/1000605/20906/i/450/depositphotos_209069270-stock-photo-tasty-hot-burger-wooden-background.jpg",
      price: 7.29,
      category: FoodCategory.burgers,
      availableAddons: [
        Addon(name: "Extra Jalapeños", price: 0.50),
        Addon(name: "Extra Hot Sauce", price: 0.70),
      ],
    ),

    // Salads
    Food(
      id: uuid.v4(),
      name: "Caesar Salad",
      description: "Romaine lettuce, croutons, parmesan, and Caesar dressing.",
      imagePath: "https://www.pngkey.com/png/detail/379-3791472_caesar-salad-caesar-salad-png.png",
      price: 6.99,
      category: FoodCategory.salads,
      availableAddons: [
        Addon(name: "Add Chicken", price: 2.00),
        Addon(name: "Add Egg", price: 1.00),
      ],
    ),
    Food(
      id: uuid.v4(),
      name: "Greek Salad",
      description: "Fresh salad with feta cheese, olives, cucumber, and tomatoes.",
      imagePath: "https://static.vecteezy.com/system/resources/previews/049/408/345/non_2x/fresh-greek-salad-in-a-bowl-with-feta-cheese-tomatoes-olives-and-cucumbers-perfect-for-a-healthy-meal-transparent-file-png.png",
      price: 6.49,
      category: FoodCategory.salads,
      availableAddons: [
        Addon(name: "Extra Olive Oil", price: 0.50),
        Addon(name: "Extra Feta", price: 1.00),
      ],
    ),
    Food(
      id: uuid.v4(),
      name: "Chicken Salad",
      description: "Grilled chicken with fresh greens, sweet corn, and vinaigrette.",
      imagePath: "https://officialpsds.com/imageview/rq/18/rq18xn_large.png?1529595429",
      price: 7.99,
      category: FoodCategory.salads,
      availableAddons: [
        Addon(name: "Extra Cheese", price: 1.00),
        Addon(name: "Add Cashews", price: 1.20),
      ],
    ),
    Food(
      id: uuid.v4(),
      name: "Fruit Salad",
      description: "Refreshing mix of watermelon, pineapple, and apples.",
      imagePath: "https://i.pinimg.com/736x/87/35/00/873500e5d6bc20a5364606b445386f4a.jpg",
      price: 5.99,
      category: FoodCategory.salads,
      availableAddons: [
        Addon(name: "Add Honey", price: 0.70),
        Addon(name: "Add Yogurt", price: 1.00),
      ],
    ),
    Food(
      id: uuid.v4(),
      name: "Tuna Salad",
      description: "Tuna salad with fresh veggies and mayo dressing.",
      imagePath: "https://www.nutritionforme.org/wp-content/uploads/2022/09/Tuna-Salad-Sandwich.png",
      price: 7.49,
      category: FoodCategory.salads,
      availableAddons: [
        Addon(name: "Add Egg", price: 1.00),
        Addon(name: "Add Sweet Corn", price: 0.80),
      ],
    ),

    // Sides
    Food(
      id: uuid.v4(),
      name: "French Fries",
      description: "Golden crispy fries, lightly salted.",
      imagePath: "https://static.vecteezy.com/system/resources/thumbnails/036/290/866/small_2x/ai-generated-french-fries-with-dipping-sauce-on-a-transparent-background-ai-png.png",
      price: 2.99,
      category: FoodCategory.sides,
      availableAddons: [
        Addon(name: "Add Cheese", price: 1.00),
        Addon(name: "Add Sauce", price: 0.50),
      ],
    ),
    Food(
      id: uuid.v4(),
      name: "Onion Rings",
      description: "Crispy battered onion rings.",
      imagePath: "https://static.vecteezy.com/system/resources/previews/055/355/981/non_2x/delicious-golden-onion-rings-on-a-dish-png.png",
      price: 3.49,
      category: FoodCategory.sides,
      availableAddons: [
        Addon(name: "Add Cheese", price: 1.00),
        Addon(name: "Add BBQ Sauce", price: 0.70),
      ],
    ),
    Food(
      id: uuid.v4(),
      name: "Garlic Bread",
      description: "Toasted garlic bread with butter.",
      imagePath: "https://static.vecteezy.com/system/resources/thumbnails/055/185/013/small_2x/cheesy-garlic-bread-with-fresh-herbs-png.png",
      price: 2.49,
      category: FoodCategory.sides,
      availableAddons: [
        Addon(name: "Add Cheese", price: 1.00),
        Addon(name: "Extra Butter", price: 0.80),
      ],
    ),
    Food(
      id: uuid.v4(),
      name: "Chicken Nuggets",
      description: "Crispy chicken nuggets served with dipping sauce.",
      imagePath: "https://img.favpng.com/3/21/24/chicken-nugget-hamburger-fried-chicken-french-fries-mcdonalds-chicken-mcnuggets-png-favpng-N4vCYubx9fNndKAuk51x29xML.jpg",
      price: 3.99,
      category: FoodCategory.sides,
      availableAddons: [
        Addon(name: "Add BBQ Sauce", price: 0.70),
        Addon(name: "Add Cheese", price: 1.00),
      ],
    ),
    Food(
      id: uuid.v4(),
      name: "Mozzarella Sticks",
      description: "Deep-fried mozzarella sticks with marinara dip.",
      imagePath: "https://w7.pngwing.com/pngs/176/238/png-transparent-pizza-onion-ring-french-fries-cheese-fries-marinara-sauce-pizza-food-recipe-cheese.png",
      price: 4.49,
      category: FoodCategory.sides,
      availableAddons: [
        Addon(name: "Add Marinara", price: 0.50),
        Addon(name: "Add Extra Cheese", price: 1.00),
      ],
    ),

    // Desserts
    Food(
      id: uuid.v4(),
      name: "Chocolate Cake",
      description: "Rich chocolate cake with soft layers.",
      imagePath: "https://static.vecteezy.com/system/resources/previews/047/842/674/non_2x/black-forest-cake-with-chocolate-sponge-cake-cherries-and-whipped-cream-png.png",
      price: 4.99,
      category: FoodCategory.desserts,
      availableAddons: [
        Addon(name: "Add Ice Cream", price: 1.50),
        Addon(name: "Extra Chocolate Syrup", price: 1.00),
      ],
    ),
    Food(
      id: uuid.v4(),
      name: "Cheesecake",
      description: "Creamy cheesecake with buttery crust.",
      imagePath: "https://aztraining.vn/wp-content/uploads/2024/11/5-7.png",
      price: 5.49,
      category: FoodCategory.desserts,
      availableAddons: [
        Addon(name: "Add Strawberries", price: 1.20),
        Addon(name: "Add Caramel", price: 1.00),
      ],
    ),
    Food(
      id: uuid.v4(),
      name: "Ice Cream",
      description: "Classic ice cream with multiple flavors.",
      imagePath: "https://static.vecteezy.com/system/resources/previews/044/570/761/non_2x/assortment-of-colorful-ice-cream-scoops-in-waffle-cones-with-fresh-fruits-on-a-transparent-background-png.png",
      price: 3.99,
      category: FoodCategory.desserts,
      availableAddons: [
        Addon(name: "Add Toppings", price: 0.80),
        Addon(name: "Add Waffle Cone", price: 0.50),
      ],
    ),
    Food(
      id: uuid.v4(),
      name: "Apple Pie",
      description: "Warm apple pie with flaky crust.",
      imagePath: "https://www.vhv.rs/dpng/d/409-4094397_apple-pie-png-free-download-apple-pie-transparent.png",
      price: 4.49,
      category: FoodCategory.desserts,
      availableAddons: [
        Addon(name: "Add Ice Cream", price: 1.50),
        Addon(name: "Add Caramel Drizzle", price: 1.00),
      ],
    ),
    Food(
      id: uuid.v4(),
      name: "Brownie",
      description: "Fudgy chocolate brownie with a soft center.",
      imagePath: "https://bellany.vn/datafiles/setone/1583291693_flavor-brownie.png",
      price: 3.99,
      category: FoodCategory.desserts,
      availableAddons: [
        Addon(name: "Add Ice Cream", price: 1.50),
        Addon(name: "Add Walnuts", price: 1.20),
      ],
    ),

    // Drinks
    Food(
      id: uuid.v4(),
      name: "Coca Cola",
      description: "Chilled Coca Cola soda.",
      imagePath: "https://atlas-content-cdn.pixelsquid.com/stock-images/coke-soda-q13q2x2-600.jpg",
      price: 1.99,
      category: FoodCategory.drinks,
      availableAddons: [
        Addon(name: "Add Ice", price: 0.20),
        Addon(name: "Add Lemon", price: 0.30),
      ],
    ),
    Food(
      id: uuid.v4(),
      name: "Orange Juice",
      description: "Freshly squeezed orange juice.",
      imagePath: "https://static.vecteezy.com/system/resources/previews/027/309/248/non_2x/orange-juice-with-ai-generated-free-png.png",
      price: 2.99,
      category: FoodCategory.drinks,
      availableAddons: [
        Addon(name: "Add Ice", price: 0.20),
        Addon(name: "Add Honey", price: 0.50),
      ],
    ),
    Food(
      id: uuid.v4(),
      name: "Milkshake",
      description: "Creamy milkshake in chocolate, vanilla, or strawberry flavor.",
      imagePath: "https://i.pinimg.com/736x/a5/a8/7a/a5a87a72eee3f7a3ff6bf7a18cbf8286.jpg",
      price: 3.99,
      category: FoodCategory.drinks,
      availableAddons: [
        Addon(name: "Add Ice Cream", price: 1.50),
        Addon(name: "Add Toppings", price: 0.80),
      ],
    ),
    Food(
      id: uuid.v4(),
      name: "Coffee",
      description: "Hot brewed coffee with rich aroma.",
      imagePath: "https://static.vecteezy.com/system/resources/thumbnails/023/742/327/small_2x/latte-coffee-isolated-illustration-ai-generative-free-png.png",
      price: 2.49,
      category: FoodCategory.drinks,
      availableAddons: [
        Addon(name: "Add Milk", price: 0.50),
        Addon(name: "Add Sugar", price: 0.20),
      ],
    ),
    Food(
      id: uuid.v4(),
      name: "Lemonade",
      description: "Refreshing homemade lemonade.",
      imagePath: "https://thumbs.dreamstime.com/b/glass-caipirinha-mojito-lemonade-caipivodka-ice-lime-transparent-background-png-356107592.jpg",
      price: 2.49,
      category: FoodCategory.drinks,
      availableAddons: [
        Addon(name: "Add Honey", price: 0.50),
        Addon(name: "Add Ginger", price: 0.40),
      ],
    ),
  ];

  List<Food> get menu => _menu;

  final foodService = FoodService();

  Future<void> uploadMenu() async {
    await foodService.addFoods(_menu);
  }

}
