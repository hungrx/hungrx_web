class GetMenuCategoryResponse {
  final bool status;
  final CategoryData data;

  GetMenuCategoryResponse({
    required this.status,
    required this.data,
  });

  factory GetMenuCategoryResponse.fromJson(Map<String, dynamic> json) {
    try {
      return GetMenuCategoryResponse(
        status: json['status'] as bool? ?? false,
        data: CategoryData.fromJson(json['data'] as Map<String, dynamic>),
      );
    } catch (e) {
      throw FormatException('Failed to parse GetMenuCategoryResponse: $e');
    }
  }
}
class CategoryData {
  final RestaurantInfo restaurant;
  final List<GetMenuCategoryModel> categories;

  CategoryData({
    required this.restaurant,
    required this.categories,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      restaurant: RestaurantInfo.fromJson(json['restaurant'] as Map<String, dynamic>),
      categories: (json['categories'] as List)
          .map((e) => GetMenuCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
class RestaurantInfo {
  final String id;
  final String name;
  final String logo;

  RestaurantInfo({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory RestaurantInfo.fromJson(Map<String, dynamic> json) {
    return RestaurantInfo(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      logo: json['logo'] as String? ?? '',
    );
  }}

class GetMenuCategoryModel {
  final String id;
  final String name;
  final List<SubcategoryModel> subcategories;
  final int totalSubcategories;
  final DateTime createdAt;
  final DateTime updatedAt;
  bool isExpanded;

  GetMenuCategoryModel({
    required this.id,
    required this.name,
    required this.subcategories,
    required this.totalSubcategories,
    required this.createdAt,
    required this.updatedAt,
    this.isExpanded = false,
  });

  factory GetMenuCategoryModel.fromJson(Map<String, dynamic> json) {
    try {
      return GetMenuCategoryModel(
        id: json['_id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        subcategories: (json['subcategories'] as List?)
            ?.map((e) => SubcategoryModel.fromJson(e as Map<String, dynamic>))
            .toList() ?? [],
        totalSubcategories: json['totalSubcategories'] as int? ?? 0,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
      );
    } catch (e) {
      throw FormatException('Failed to parse GetMenuCategoryModel: $e');
    }
  }
}

class SubcategoryModel {
  final String id;
  final String name;

  SubcategoryModel({
    required this.id,
    required this.name,
  });

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) {
    try {
      return SubcategoryModel(
        id: json['_id'] as String? ?? '',
        name: json['name'] as String? ?? '',
      );
    } catch (e) {
      throw FormatException('Failed to parse SubcategoryModel: $e');
    }
  }
}