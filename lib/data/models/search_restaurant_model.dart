class SearchRestaurantModel {
  final String id;
  final String name;
  final String logo;
  final String? description;
  final double? rating;
  final String? createdAt;
  final String? updatedAt;
  final CategoryInfo? category;

  SearchRestaurantModel({
    required this.id,
    required this.name,
    required this.logo,
    this.description,
    this.rating,
    this.createdAt,
    this.updatedAt,
    this.category,
  });

  factory SearchRestaurantModel.fromJson(Map<String, dynamic> json) {
    return SearchRestaurantModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      description: json['description'],
      rating: json['rating']?.toDouble(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      category: json['category'] != null
          ? CategoryInfo.fromJson(json['category'])
          : null,
    );
  }
}

class CategoryInfo {
  final String id;
  final String name;

  CategoryInfo({
    required this.id,
    required this.name,
  });

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
