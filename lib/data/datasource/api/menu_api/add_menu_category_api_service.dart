import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_web/core/constant/api_constant.dart';
import 'package:hungrx_web/core/error/menu_exceptions.dart';

// this is the file for create menu main category 

class MenuApiService {
  final http.Client client;

  MenuApiService({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> createCategory(String restaurantId, String name) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.addMenuCategory}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'restaurantId': restaurantId,
          'name': name,
        }),
      );

      final Map<String, dynamic> responseData = json.decode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        if (responseData.containsKey('category')) {  // Changed from 'data' to 'category'
          return responseData;
        } else {
          throw MenuException(
            'Invalid response format: missing category data',
            response.statusCode,
          );
        }
      } else {
        throw MenuException(
          responseData['error'] ?? 'Failed to create category',
          
        );
      }
    } on FormatException {
      throw MenuException('Invalid response format');
    } catch (e) {
      throw MenuException('Network error: ${e.toString()}');
    }
  }
}