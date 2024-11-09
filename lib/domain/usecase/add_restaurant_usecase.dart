import 'package:hungrx_web/data/models/add_restaurant_model.dart';
import 'package:hungrx_web/data/repositories/add_restaurant_repository.dart';

class AddRestaurantUseCase {
  final AddRestaurantRepository _repository;

  AddRestaurantUseCase({AddRestaurantRepository? repository})
      : _repository = repository ?? AddRestaurantRepository();

  Future<Map<String, dynamic>> execute(AddRestaurantModel restaurant) async {
    try {
      return await _repository.addRestaurant(restaurant);
    } catch (e) {
      throw Exception('UseCase error: $e');
    }
  }
}
