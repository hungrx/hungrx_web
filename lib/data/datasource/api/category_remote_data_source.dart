import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_web/core/constant/api_constant.dart';
import 'package:hungrx_web/core/error/failures.dart';
import 'package:hungrx_web/data/models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final http.Client client;

  CategoryRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await client.get(
        Uri.parse(ApiConstants.getAllCategories),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          final categoriesJson = jsonResponse['data']['categories'] as List;
          return categoriesJson
              .map((category) => CategoryModel.fromJson(category))
              .toList();
        } else {
          throw const ServerFailure('Invalid response format');
        }
      } else {
        throw ServerFailure('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw NetworkFailure(e.toString());
    }
  }
}
