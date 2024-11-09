import 'package:hungrx_web/data/datasource/api/add_restaurant_api.dart';
import 'package:hungrx_web/data/models/add_restaurant_model.dart';

class AddRestaurantRepository {
  final AddRestaurantApiClient _apiClient;

  AddRestaurantRepository({AddRestaurantApiClient? apiClient})
      : _apiClient = apiClient ?? AddRestaurantApiClient();

  Future<Map<String, dynamic>> addRestaurant(AddRestaurantModel restaurant) async {
    try {
      return await _apiClient.addRestaurant(restaurant);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}