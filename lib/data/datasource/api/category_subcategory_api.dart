import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_web/data/models/add_subcategory_response.dart';
import 'package:hungrx_web/data/models/menu_category_subcategory_response.dart';

class CategorySubcategoryApi {
  final String baseUrl = 'https://hungrxadmin.onrender.com';
  final http.Client client;

  CategorySubcategoryApi({http.Client? client})
      : client = client ?? http.Client();

  Future<CategorySubcategoryResponse> getCategoriesAndSubcategories() async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/files/getCategoryandSubcategories'),
      );

      if (response.statusCode == 200) {
        return CategorySubcategoryResponse.fromJson(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<AddSubcategoryResponse> addMenuSubcategory(
    String categoryId,
    String name,
  ) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/files/addMenuSubcategory'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'categoryId': categoryId,
          'name': name,
        }),
      );
// print(response.body);
// print(response.statusCode);
      if (response.statusCode == 201) {
        return AddSubcategoryResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add subcategory');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}
