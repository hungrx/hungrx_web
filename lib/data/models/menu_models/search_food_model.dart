class Food {
  final String id;
  final String name;
  final String imageUrl;
  final String lastUpdated;
  final String? category;
  final String? subCategory;
  final NutritionInfo nutritionInfo;

  Food({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.lastUpdated,
    this.category,
    this.subCategory,
    required this.nutritionInfo,
  });

  // Convert Food instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'lastUpdated': lastUpdated,
      'category': category,
      'subCategory': subCategory,
      'nutritionInfo': nutritionInfo.toJson(),
    };
  }

  // Create Food instance from JSON
  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      lastUpdated: json['lastUpdated'],
      category: json['category'],
      subCategory: json['subCategory'],
      nutritionInfo: NutritionInfo.fromJson(json['nutritionInfo']),
    );
  }
}

class NutritionInfo {
  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  NutritionInfo({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  // Convert NutritionInfo instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }

  // Create NutritionInfo instance from JSON
  factory NutritionInfo.fromJson(Map<String, dynamic> json) {
    return NutritionInfo(
      calories: json['calories'],
      protein: json['protein'],
      carbs: json['carbs'],
      fat: json['fat'],
    );
  }
}