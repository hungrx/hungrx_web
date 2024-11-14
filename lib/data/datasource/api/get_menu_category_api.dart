import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:hungrx_web/data/models/get_menu_category_response.dart';

class GetMenuCategoryApi {
  final http.Client client;
  final String baseUrl;

  GetMenuCategoryApi({
    required this.client,
    this.baseUrl = 'https://hungrxadmin.onrender.com',
  });

  Future<GetMenuCategoryResponse> getMenuCategories(String restaurantId) async {
    try {
      
      final response = await client
          .post(
            Uri.parse('$baseUrl/files/getMenuCategory'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'restaurantId': restaurantId,
            }),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw TimeoutException('Request timed out'),
          );
print(response.body);
      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body) as Map<String, dynamic>;
        return GetMenuCategoryResponse.fromJson(decodedResponse);
      } else {
        throw HttpException(
            'Failed to load menu categories: ${response.statusCode}');
      }
    } on FormatException catch (e) {
      throw FormatException('Invalid response format: $e');
    } on TimeoutException {
      throw TimeoutException('Request timed out');
    } on HttpException catch (e) {
      throw HttpException(e.message);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}