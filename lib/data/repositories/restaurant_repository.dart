import 'package:hungrx_web/data/datasource/api/restaurant_api_service.dart';
import 'package:hungrx_web/data/models/restaurant_model.dart';

class RestaurantRepository {
  final RestaurantApiService _apiService;

  RestaurantRepository({RestaurantApiService? apiService})
      : _apiService = apiService ?? RestaurantApiService();

  Future<List<RestaurantModel>> getRestaurants() async {
    try {
      final restaurantData = await _apiService.getRestaurants();
      return restaurantData
          .map((json) => RestaurantModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}
