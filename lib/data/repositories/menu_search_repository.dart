
import 'package:hungrx_web/core/error/menu_exceptions.dart';
import 'package:hungrx_web/data/datasource/api/menu_search_api.dart';

import '../models/menu_search_response.dart';


class MenuSearchRepository {
  final MenuSearchApi api;

  MenuSearchRepository({required this.api});

  Future<MenuSearchResponse> searchMenu({
    required String query,
    required String restaurantId,
  }) async {
    try {
      final response = await api.searchMenu(
        query: query,
        restaurantId: restaurantId,
      );
      return MenuSearchResponse.fromJson(response);
    } on MenuException {
      rethrow;
    } catch (e) {
      throw MenuException(

         'Unexpected error occurred',
         500,
      );
    }
  }
}