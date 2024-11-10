class RestaurantModel {
  final String id;
  final String name;
  final String logo;
  final double? rating;
  final String? description;
  final String? category;
  final String? createdAt;
  final String? updatedAt;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.logo,
    this.rating,
    this.description,
    this.category,
    this.createdAt,
    this.updatedAt,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      logo: json['logo'] as String,
      rating: json['rating']?.toDouble(),
      description: json['description'] as String?,
      category: json['category'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'logo': logo,
    'rating': rating,
    'description': description,
    'category': category,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}