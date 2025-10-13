class Food {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final double price;
  final FoodCategory category;
  final List<Addon> availableAddons;

  Food({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.category,
    required this.availableAddons,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'imagePath': imagePath,
    'price': price,
    'category': category.name,
    'availableAddons': availableAddons.map((a) => a.toJson()).toList(),
  };

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    imagePath: json['imagePath'],
    price: (json['price'] as num).toDouble(),
    category: FoodCategory.values.firstWhere(
          (e) => e.name == json['category'],
      orElse: () => FoodCategory.burgers,
    ),
    availableAddons: (json['availableAddons'] as List)
        .map((a) => Addon.fromJson(a))
        .toList(),
  );
}

enum FoodCategory {
  burgers,
  salads,
  sides,
  desserts,
  drinks,
}

class Addon {
  final String name;
  final double price;

  Addon({
    required this.name,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
  };

  factory Addon.fromJson(Map<String, dynamic> json) => Addon(
    name: json['name'],
    price: (json['price'] as num).toDouble(),
  );
}