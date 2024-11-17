import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_web/data/models/menu_models/add_menu_subcategory_model.dart';

class AddMenuSubcategoryApi {
  final String baseUrl;

  AddMenuSubcategoryApi({required this.baseUrl});

  Future<AddMenuSubcategoryResponse> createSubcategory(
      AddMenuSubcategoryRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/files/addMenuSubcategory'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );
      if (response.statusCode == 201) {
        return AddMenuSubcategoryResponse.fromJson(json.decode(response.body));
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to create subcategory');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}