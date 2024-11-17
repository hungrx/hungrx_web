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
    String? id,
    String? name,
    String? logoUrl,
    String? categoryId,
    double? rating,
    String? description,
    Uint8List? logoBytes,
    String? logoName,
  }) {
    return EditRestaurantModel(
      id: id ?? this.id,
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
      id: json['_id'] as String,
      name: json['name'] as String,
      categoryId: (json['category'] as Map<String, dynamic>)['_id'] as String,
      rating: (json['rating'] as num).toDouble(),
      description: json['description'] as String,
    );
  }
}