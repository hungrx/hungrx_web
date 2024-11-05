import 'dart:convert';
import 'package:http/http.dart' as http;

class RestaurantApiService {
  static const String baseUrl = 'https://hungrxadmin.onrender.com';

  Future<List<Map<String, dynamic>>> getRestaurants() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/files/getRestaurant'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['restaurantNameAndLogo']);
      } else {
        throw Exception('Failed to load restaurants: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}