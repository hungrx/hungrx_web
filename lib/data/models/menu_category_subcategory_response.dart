class CategorySubcategoryResponse {
  final bool status;
  final CategorySubcategoryData data;

  CategorySubcategoryResponse({required this.status, required this.data});

  factory CategorySubcategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategorySubcategoryResponse(
      status: json['status'] ?? false,
      data: CategorySubcategoryData.fromJson(json['data']),
    );
  }
}

class CategorySubcategoryData {
  final int totalCategories;
  final int totalSubcategories;
  final List<Category> categories;

  CategorySubcategoryData({
    required this.totalCategories,
    required this.totalSubcategories,
    required this.categories,
  });

  factory CategorySubcategoryData.fromJson(Map<String, dynamic> json) {
    return CategorySubcategoryData(
      totalCategories: json['totalCategories'] ?? 0,
      totalSubcategories: json['totalSubcategories'] ?? 0,
      categories: (json['categories'] as List)
          .map((category) => Category.fromJson(category))
          .toList(),
    );
  }
}

class Category {
  final String id;
  final String name;
  final List<Subcategory> subcategories;
  final int totalSubcategories;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.subcategories,
    required this.totalSubcategories,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      subcategories: (json['subcategories'] as List)
          .map((subcategory) => Subcategory.fromJson(subcategory))
          .toList(),
      totalSubcategories: json['totalSubcategories'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? ''),
      updatedAt: DateTime.parse(json['updatedAt'] ?? ''),
    );
  }
}

class Subcategory {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Subcategory({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? ''),
      updatedAt: DateTime.parse(json['updatedAt'] ?? ''),
    );
  }
}