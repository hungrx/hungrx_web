class DishEditModel {
  final String name;
  final double price;
  final double rating;
  final String description;
  final String calories;
  final String carbs;
  final String protein;
  final String fats;
  final String servingSize;
  final String servingUnit;
  final String categoryId;
  final String restaurantId;
  final String menuId;
  final String dishId;
  final String subcategoryId;
  final String? image;

  DishEditModel({
    required this.name,
    required this.price,
    required this.rating,
    required this.description,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fats,
    required this.servingSize,
    required this.servingUnit,
    required this.categoryId,
    required this.restaurantId,
    required this.menuId,
    required this.dishId,
    required this.subcategoryId,
    this.image,
  });

  factory DishEditModel.fromJson(Map<String, dynamic> json) {
    return DishEditModel(
      name: json['name'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      description: json['description'] ?? '',
      calories: json['calories'] ?? '',
      carbs: json['carbs'] ?? '',
      protein: json['protein'] ?? '',
      fats: json['fats'] ?? '',
      servingSize: json['servingSize'] ?? '',
      servingUnit: json['servingUnit'] ?? 'g',
      categoryId: json['categoryId'] ?? '',
      restaurantId: json['restaurantId'] ?? '',
      menuId: json['menuId'] ?? '',
      dishId: json['dishId'] ?? '',
      subcategoryId: json['subcategoryId'] ?? '',
      image: json['image'],
    );
  }
}