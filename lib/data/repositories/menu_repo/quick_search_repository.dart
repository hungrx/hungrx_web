import 'package:hungrx_web/data/datasource/api/menu_api/quick_search_api.dart';
import 'package:hungrx_web/data/models/menu_models/quick_search_response.dart';

class QuickSearchRepository {
  final QuickSearchApi _api;

  QuickSearchRepository({required QuickSearchApi api}) : _api = api;

  Future<List<DishItem>> searchDishes(String query, String restaurantId) async {
    try {
      final response = await _api.searchDishes(query, restaurantId);
      return response.data.suggestions.dishes;
    } catch (e) {
      throw Exception('Failed to fetch dishes: $e');
    }
  }
}