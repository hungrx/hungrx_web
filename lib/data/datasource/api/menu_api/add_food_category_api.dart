import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_web/data/models/menu_models/add_food_category_request.dart';
import 'package:hungrx_web/data/models/menu_models/add_food_category_response.dart';

class AddFoodCategoryApi {
  static const String baseUrl = 'https://hungrxadmin.onrender.com';

  Future<AddFoodCategoryResponse> addFoodToCategory(AddFoodCategoryRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/files/addDishToCategory'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
print(response.body);
print(response.statusCode);
      if (response.statusCode == 200) {
        return AddFoodCategoryResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add food to category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding food to category: $e');
    }
  }
}