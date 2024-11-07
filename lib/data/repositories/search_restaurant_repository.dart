import 'package:hungrx_web/data/datasource/api/search_restaurant_api.dart';
import 'package:hungrx_web/data/models/search_restaurant_model.dart';

class SearchRestaurantRepository {
  final SearchRestaurantApi _api;

  SearchRestaurantRepository(this._api);

  Future<List<SearchRestaurantModel>> searchRestaurants(String query) async {
    return await _api.searchRestaurants(query);
  }
}