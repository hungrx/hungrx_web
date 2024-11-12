import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_web/core/constant/api_constant.dart';
import 'package:hungrx_web/core/error/menu_exceptions.dart';

class MenuApiService {
  final http.Client client;

  MenuApiService({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> createCategory(String name) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.addMenuCategory}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name}),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw MenuException(
          'Failed to create category',
          response.statusCode,
        );
      }
    } catch (e) {
      throw MenuException('Network error: ${e.toString()}');
    }
  }
}