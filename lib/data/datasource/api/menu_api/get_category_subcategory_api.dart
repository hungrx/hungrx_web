import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_web/data/models/menu_models/get_category_subcategory_model.dart';

class GetCategorySubcategoryApi {
  final String baseUrl;

  GetCategorySubcategoryApi({required this.baseUrl});

  Future<GetCategorySubcategoryResponse> getCategoriesAndSubcategories(
      String restaurantId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/files/getMenuAndSubCategory'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'restaurantId': restaurantId}),
      );
// print(response.body);
// print(response.statusCode);
      if (response.statusCode == 200) {
        return GetCategorySubcategoryResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}
