import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_web/data/models/menu_models/dish_model.dart';

class DishApiService {
  static const String baseUrl = 'https://hungrxadmin.onrender.com';

  Future<Map<String, dynamic>> createNewDish(DishModel dish) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/files/addDish'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dish.toJson()),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create dish: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}