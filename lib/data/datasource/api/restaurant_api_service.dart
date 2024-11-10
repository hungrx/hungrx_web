import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:hungrx_web/core/constant/api_constant.dart';
import 'package:hungrx_web/core/error/failures.dart';

class RestaurantApiService {
  final http.Client client;

  RestaurantApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Map<String, dynamic>>> getRestaurants() async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConstants.baseUrl}/files/getRestaurant'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final restaurants = List<Map<String, dynamic>>.from(data['restaurants']);
        
        return restaurants.map((restaurant) {
          var logo = restaurant['logo'] as String;
          if (logo.startsWith('http://')) {
            logo = 'https://${logo.substring(7)}';
          }
          restaurant['logo'] = logo;
          return restaurant;
        }).toList();
      } else {
        throw ServerFailure('Failed to load restaurants: ${response.statusCode}');
      }
    } catch (e) {
      throw NetworkFailure('Network error: $e');
    }
  }

  Future<void> deleteRestaurant(String id) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConstants.baseUrl}/files/deleteRestaurant/$id'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw ServerFailure('Failed to delete restaurant: ${response.statusCode}');
      }
    } catch (e) {
      throw NetworkFailure('Network error during deletion: $e');
    }
  }
}