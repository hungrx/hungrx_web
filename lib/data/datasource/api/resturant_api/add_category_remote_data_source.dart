import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_web/core/constant/api_constant.dart';
import 'package:hungrx_web/core/error/failures.dart';
import 'package:hungrx_web/data/models/restaurant_models/add_category_model.dart';
import 'package:hungrx_web/data/models/restaurant_models/add_category_response.dart';

// create new restaurant categories 
class AddCategoryDataSource {
  final http.Client client;

  AddCategoryDataSource({required this.client});

  Future<AddCategoryResponse> addCategory(AddCategoryRequest request) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}/files/addCategory'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        return AddCategoryResponse.fromJson(jsonResponse);
      } else {
        throw ServerFailure('Failed to add category: ${response.statusCode}');
      }
    } catch (e) {
      throw NetworkFailure(e.toString());
    }
  }
}