import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:hungrx_web/data/models/menu_models/edit_menu_category_request.dart';
import 'package:hungrx_web/data/models/menu_models/edit_menu_category_response.dart';

class CategoryApiService {
  static const String baseUrl = 'https://hungrxadmin.onrender.com/files';

  Future<EditCategoryResponse> editCategory(EditCategoryRequest request) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/editMenuCategory'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
print(response.body);

      if (response.statusCode == 200) {
        return EditCategoryResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to edit category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to edit category: $e');
    }
  }
}