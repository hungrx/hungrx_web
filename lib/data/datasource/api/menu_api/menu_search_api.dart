import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_web/core/constant/api_constant.dart';
import 'package:hungrx_web/core/error/menu_exceptions.dart';


class MenuSearchApi {
  final http.Client client;

  MenuSearchApi({required this.client});

  Future<Map<String, dynamic>> searchMenu({
    required String query,
    required String restaurantId,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}/files/searchMenu'),
        body: jsonEncode({
          'query': query,
          'restaurantId': restaurantId,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw MenuException(
          'Failed to search menu',
          response.statusCode,
        );
      }
    } catch (e) {
      throw MenuException(
         'Network error occurred',
         500,
      );
    }
  }
}