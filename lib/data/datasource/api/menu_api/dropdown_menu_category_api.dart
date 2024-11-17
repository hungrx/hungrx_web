import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_web/core/constant/api_constant.dart';
import 'package:hungrx_web/data/models/menu_models/dropdown_menu_category_model.dart';

class DropdownMenuCategoryApi {
  final String baseUrl;

  DropdownMenuCategoryApi({required this.baseUrl});

  Future<DropdownMenuCategoryResponse> getCategories(String restaurantId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiConstants.dropdownMenuCategory}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'restaurantId': restaurantId}),
      );

      if (response.statusCode == 200) {
        return DropdownMenuCategoryResponse.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}