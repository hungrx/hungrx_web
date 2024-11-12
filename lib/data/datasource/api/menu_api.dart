import 'package:http/http.dart' as http;
import 'package:hungrx_web/core/error/menu_exception.dart';
import 'dart:convert';

import 'package:hungrx_web/data/models/menu_model.dart';

class MenuApi {
  final String baseUrl = 'https://hungrxadmin.onrender.com';

  Future<MenuResponse> getMenu(String restaurantId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/files/getMenu'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'restaurantId': restaurantId}),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('Request timed out'),
      );

      if (response.statusCode == 200) {
        try {
          return MenuResponse.fromJson(json.decode(response.body));
        } catch (e) {
          throw FormatException('Failed to parse response: $e');
        }
      } else if (response.statusCode == 404) {
        throw NotFoundException('Restaurant not found');
      } else if (response.statusCode >= 500) {
        throw ServerException('Server error occurred');
      } else {
        throw ApiException('Failed to load menu: ${response.statusCode}');
      }
    } on TimeoutException {
      throw TimeoutException('Request timed out');
    } on FormatException catch (e) {
      throw FormatException('Invalid response format: $e');
    } catch (e) {
      throw NetworkException('Network error: $e');
    }
  }
}