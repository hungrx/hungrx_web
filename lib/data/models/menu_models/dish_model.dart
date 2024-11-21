class DishModel {
  final String name;
  final double price;
  final double rating;
  final String description;
  final int calories;
  final int carbs;
  final int protein;
  final int fats;
  final int servingSize;
  final String servingUnit;
  final String restaurantId;
  final String menuId;

  DishModel({
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
    required this.restaurantId,
    required this.menuId,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'rating': rating,
        'description': description,
        'calories': calories,
        'carbs': carbs,
        'protein': protein,
        'fats': fats,
        'servingSize': servingSize,
        'servingUnit': servingUnit,
        'restaurantId': restaurantId,
        'menuId': menuId,
      };

  factory DishModel.fromJson(Map<String, dynamic> json) => DishModel(
        name: json['name'],
        price: json['price'].toDouble(),
        rating: json['rating'].toDouble(),
        description: json['description'],
        calories: json['calories'],
        carbs: json['carbs'],
        protein: json['protein'],
        fats: json['fats'],
        servingSize: json['servingSize'],
        servingUnit: json['servingUnit'],
        restaurantId: json['restaurantId'],
        menuId: json['menuId'],
      );
}