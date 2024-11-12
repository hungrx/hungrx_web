import 'package:hungrx_web/data/models/category_model.dart';

class RestaurantModel {
  final String id;
  final String name;
  final String logo;
  final double? rating;
  final String? description;
  final CategoryModel? category;
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
    try {
      return RestaurantModel(
        id: json['_id']?.toString() ?? '',  // Convert to String safely
        name: json['name']?.toString() ?? '',
        logo: json['logo']?.toString() ?? '',
        rating: json['rating'] == null 
            ? null 
            : double.tryParse(json['rating'].toString()),  // Safe conversion
        description: json['description']?.toString(),
        category: json['category'] == null 
            ? null 
            : CategoryModel.fromJson(json['category']),
        createdAt: json['createdAt']?.toString(),
        updatedAt: json['updatedAt']?.toString(),
      );
    } catch (e) {
      print('Error parsing RestaurantModel: $e');
      // Return a default model or rethrow based on your needs
      throw Exception('Failed to parse restaurant data: $e');
    }
  
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