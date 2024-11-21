import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_web/data/models/menu_models/quick_search_response.dart';

class QuickSearchApi {
  static const String baseUrl = 'https://hungrxadmin.onrender.com';

  Future<QuickSearchResponse> searchDishes(String query, String restaurantId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/files/searchMenu'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'restaurantId': restaurantId,
          'query': query,
        }),
      );
print(response.body);
      if (response.statusCode == 200) {
        return QuickSearchResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to search dishes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}