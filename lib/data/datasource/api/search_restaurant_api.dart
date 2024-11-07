import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_web/data/models/search_restaurant_model.dart';

class SearchRestaurantApi {
  final String baseUrl = 'https://hungrxadmin.onrender.com';

  Future<List<SearchRestaurantModel>> searchRestaurants(String query) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/files/searchRestuarant'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': query}),
      );
print(response.body);
print(response.statusCode);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> restaurants = data['restaurants'];
        return restaurants
            .map((json) => SearchRestaurantModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to search restaurants');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}
