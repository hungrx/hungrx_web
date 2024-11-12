import 'package:hungrx_web/core/error/exceptions.dart';
import 'package:hungrx_web/data/datasource/api/edit_restaurant_api.dart';
import 'package:hungrx_web/data/models/edit_restaurant_model.dart';

class EditRestaurantRepository {
  final _api = EditRestaurantApi();

  Future<EditRestaurantModel> updateRestaurant(
      EditRestaurantModel restaurant) async {
    try {
      final response = await _api.updateRestaurant(
        restaurantId: restaurant.id,
        name: restaurant.name,
        categoryId: restaurant.categoryId,
        rating: restaurant.rating,
        description: restaurant.description,
        logoBytes: restaurant.logoBytes,
        logoName: restaurant.logoName,
      );
      if (response['restaurant'] != null) {
        return EditRestaurantModel.fromJson(response['restaurant']);
      } else {
        // If no restaurant data, but status is true, create a model from existing data
        if (response['status'] == true) {
          return restaurant;
        }
        throw EditRestaurantServerException('Invalid response format');
      }
    } on EditRestaurantServerException {
      rethrow;
    } on EditRestaurantNetworkException {
      rethrow;
    } catch (e) {
      throw EditRestaurantServerException('Error updating restaurant: $e');
    }
  }
}
