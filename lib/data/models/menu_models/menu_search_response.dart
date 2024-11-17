class MenuSearchResponse {
  final bool status;
  final MenuSearchData data;

  MenuSearchResponse({required this.status, required this.data});

  factory MenuSearchResponse.fromJson(Map<String, dynamic> json) {
    return MenuSearchResponse(
      status: json['status'] ?? false,
      data: MenuSearchData.fromJson(json['data'] ?? {}),
    );
  }
}

class MenuSearchData {
  final Restaurant restaurant;
  final List<MenuSection> results;
  final int totalResults;
  final List<Category>? categories; 

  MenuSearchData({
    required this.restaurant,
    required this.results,
     this.totalResults=0,
    this.categories,
  });

  factory MenuSearchData.fromJson(Map<String, dynamic> json) {
    final resultsList = json['results'] as List?;
    final categoriesList = json['categories'] as List?;
    final results = resultsList?.map((e) => MenuSection.fromJson(e)).toList() ?? [];
    

    return MenuSearchData(
      restaurant: Restaurant.fromJson(json['restaurant'] ?? {}),
      results:results,
      totalResults: json['totalResults'] ?? results.fold(0, (sum, section) => sum + section.dishes.length), // Calculate total results from the list length
      categories: categoriesList?.map((e) => Category.fromJson(e)).toList(),
    );
  }
  bool hasValidResults() {
    return results.isNotEmpty && results.any((section) => section.dishes.isNotEmpty);
  }
}

class Restaurant {
  final String id;
  final String name;
  final String logo;
  final Category? category;  
  final int? rating;  
  final String updatedAt;
  final String? createdAt; 

  Restaurant({
    required this.id,
    required this.name,
    required this.logo,
    this.category,
    this.rating,
    required this.updatedAt,
    this.createdAt,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      rating: json['rating'],
      updatedAt: json['updatedAt'] ?? '',
      createdAt: json['createdAt'],
    );
  }
}

class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class MenuSection {
  final String menuName;
  final List<Dish> dishes;

  MenuSection({required this.menuName, required this.dishes});

  factory MenuSection.fromJson(Map<String, dynamic> json) {
    return MenuSection(
      menuName: json['menuName'] ?? '',
      dishes: (json['dishes'] as List? ?? [])
          .map((e) => Dish.fromJson(e))
          .toList(),
    );
  }
}

class Dish {
  final String id;
  final String name;
  final String image;
  final ServingInfo servingInfo;
  final NutritionFacts nutritionFacts;

  Dish({
    required this.id,
    required this.name,
    required this.image,
    required this.servingInfo,
    required this.nutritionFacts,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      servingInfo: ServingInfo.fromJson(json['servingInfo'] ?? {}),
      nutritionFacts: NutritionFacts.fromJson(json['nutritionFacts'] ?? {}),
    );
  }
}

class ServingInfo {
  final double size;
  final String unit;
  final String equivalentTo;

  ServingInfo({
    required this.size,
    required this.unit,
    required this.equivalentTo,
  });

  factory ServingInfo.fromJson(Map<String, dynamic> json) {
    return ServingInfo(
      size: (json['size'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      equivalentTo: json['equivalentTo'] ?? '',
    );
  }
}

class NutritionFacts {
  final int calories;
  final NutrientValue totalFat;
  final NutrientValue saturatedFat;
  final NutrientValue transFat;
  final NutrientValue cholesterol;
  final NutrientValue sodium;
  final NutrientValue totalCarbohydrates;
  final NutrientValue dietaryFiber;
  final NutrientValue sugars;
  final NutrientValue protein;

  NutritionFacts({
    required this.calories,
    required this.totalFat,
    required this.saturatedFat,
    required this.transFat,
    required this.cholesterol,
    required this.sodium,
    required this.totalCarbohydrates,
    required this.dietaryFiber,
    required this.sugars,
    required this.protein,
  });

  factory NutritionFacts.fromJson(Map<String, dynamic> json) {
    return NutritionFacts(
      calories: json['calories'] ?? 0,
      totalFat: NutrientValue.fromJson(json['totalFat'] ?? {}),
      saturatedFat: NutrientValue.fromJson(json['saturatedFat'] ?? {}),
      transFat: NutrientValue.fromJson(json['transFat'] ?? {}),
      cholesterol: NutrientValue.fromJson(json['cholesterol'] ?? {}),
      sodium: NutrientValue.fromJson(json['sodium'] ?? {}),
      totalCarbohydrates: NutrientValue.fromJson(json['totalCarbohydrates'] ?? {}),
      dietaryFiber: NutrientValue.fromJson(json['dietaryFiber'] ?? {}),
      sugars: NutrientValue.fromJson(json['sugars'] ?? {}),
      protein: NutrientValue.fromJson(json['protein'] ?? {}),
    );
  }
}

class NutrientValue {
  final int value;

  NutrientValue({required this.value});

  factory NutrientValue.fromJson(Map<String, dynamic> json) {
    return NutrientValue(
      value: json['value'] ?? 0,
    );
  }
}