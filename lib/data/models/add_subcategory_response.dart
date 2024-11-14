import 'package:hungrx_web/data/models/menu_category_subcategory_response.dart';

class AddSubcategoryResponse {
  final bool status;
  final String message;
  final Category category;

  AddSubcategoryResponse({
    required this.status,
    required this.message,
    required this.category,
  });

  factory AddSubcategoryResponse.fromJson(Map<String, dynamic> json) {
    return AddSubcategoryResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      category: Category.fromJson(json['category']),
    );
  }
}