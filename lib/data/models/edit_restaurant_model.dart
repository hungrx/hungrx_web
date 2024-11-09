import 'dart:typed_data';

class EditRestaurantModel {
  final String id;
  final String name;
  final String? logoUrl;
  final String categoryId;
  final double rating;
  final String description;
  final Uint8List? logoBytes;
  final String? logoName;

  EditRestaurantModel({
    required this.id,
    required this.name,
    this.logoUrl,
    required this.categoryId,
    required this.rating,
    required this.description,
    this.logoBytes,
    this.logoName,
  });

  EditRestaurantModel copyWith({
    String? name,
    String? logoUrl,
    String? categoryId,
    double? rating,
    String? description,
    Uint8List? logoBytes,
    String? logoName,
  }) {
    return EditRestaurantModel(
      id: id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      categoryId: categoryId ?? this.categoryId,
      rating: rating ?? this.rating,
      description: description ?? this.description,
      logoBytes: logoBytes ?? this.logoBytes,
      logoName: logoName ?? this.logoName,
    );
  }

  factory EditRestaurantModel.fromJson(Map<String, dynamic> json) {
    return EditRestaurantModel(
      id: json['_id'],
      name: json['name'],
      logoUrl: json['logo'],
      categoryId: json['category'] ?? '',
      rating: json['rating'].toDouble(),
      description: json['description'],
    );
  }
}