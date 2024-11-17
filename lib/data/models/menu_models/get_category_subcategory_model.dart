class GetCategorySubcategoryResponse {
  final bool status;
  final RestaurantData restaurant;

  GetCategorySubcategoryResponse({
    required this.status,
    required this.restaurant,
  });

  factory GetCategorySubcategoryResponse.fromJson(Map<String, dynamic> json) {
    return GetCategorySubcategoryResponse(
      status: json['status'] as bool,
      restaurant: RestaurantData.fromJson(json['restaurant']),
    );
  }
}

class RestaurantData {
  final String id;
  final List<MenuCategory> menuCategories;

  RestaurantData({
    required this.id,
    required this.menuCategories,
  });

  factory RestaurantData.fromJson(Map<String, dynamic> json) {
    return RestaurantData(
      id: json['_id'] as String,
      menuCategories: (json['menuCategories'] as List)
          .map((category) => MenuCategory.fromJson(category))
          .toList(),
    );
  }
}

class MenuCategory {
  final String id;
  final String name;
  final List<SubCategory> subcategories;
  bool isExpanded;

  MenuCategory({
    required this.id,
    required this.name,
    required this.subcategories,
    this.isExpanded = false,
  });

  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    return MenuCategory(
      id: json['_id'] as String,
      name: json['name'] as String,
      subcategories: (json['subcategories'] as List? ?? [])
          .map((subcategory) => SubCategory.fromJson(subcategory))
          .toList(),
    );
  }
}

class SubCategory {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubCategory({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['_id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}