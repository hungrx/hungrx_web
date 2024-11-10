import 'package:hungrx_web/core/error/exceptions.dart';
import 'package:hungrx_web/data/datasource/api/edit_restaurant_api.dart';
import 'package:hungrx_web/data/models/edit_restaurant_model.dart';

class EditRestaurantRepository {
  final _api = EditRestaurantApi();

  Future<EditRestaurantModel> updateRestaurant(EditRestaurantModel restaurant) async {
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
        throw EditRestaurantServerException('Invalid response format');
      }
    } catch (e) {
      rethrow;
    }
  }
}
