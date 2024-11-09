import 'dart:typed_data';

class AddRestaurantModel {
  final String name;
  final String categoryId;
  final double rating;
  final String description;
  final Uint8List? logoBytes;
  final String? logoName;

  AddRestaurantModel({
    required this.name,
    required this.categoryId,
    required this.rating,
    required this.description,
    this.logoBytes,
    this.logoName,
  });

  Map<String, String> toFormData() {
    return {
      'name': name,
      'categoryId': categoryId,
      'rating': rating.toString(),
      'description': description,
    };
  }
}