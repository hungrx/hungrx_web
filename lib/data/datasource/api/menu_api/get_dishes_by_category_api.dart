import 'dart:convert';
import 'package:http/http.dart' as http;

class GetDishesByCategoryApi {
  final String baseUrl = 'https://hungrxadmin.onrender.com';

  Future<Map<String, dynamic>> getDishesByCategory({
    required String restaurantId,
    required String categoryId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/files/getRestaurantsByCategory'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'restaurantId': restaurantId,
          'categoryId': categoryId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch dishes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}