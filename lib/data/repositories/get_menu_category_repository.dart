import 'dart:async';

import 'package:hungrx_web/data/datasource/api/get_menu_category_api.dart';
import 'package:hungrx_web/data/models/get_menu_category_response.dart';


class GetMenuCategoryRepository {
  final GetMenuCategoryApi api;

  GetMenuCategoryRepository({required this.api});

  Future<CategoryData> getMenuCategories(String restaurantId) async {
    try {
      final response = await api.getMenuCategories(restaurantId);
      if (!response.status) {
        throw Exception('API returned status false');
      }
      return response.data;
    } on TimeoutException {
      throw TimeoutException('Request timed out');
    } on FormatException catch (e) {
      throw FormatException('Data parsing error: $e');
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}