import 'package:hungrx_web/data/models/search_restaurant_model.dart';
import 'package:hungrx_web/data/repositories/search_restaurant_repository.dart';

class SearchRestaurantsUseCase {
  final SearchRestaurantRepository _repository;

  SearchRestaurantsUseCase(this._repository);

  Future<List<SearchRestaurantModel>> execute(String query) async {
    return await _repository.searchRestaurants(query);
  }
}