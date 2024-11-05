import 'package:hungrx_web/data/models/restaurant_model.dart';
import 'package:hungrx_web/data/repositories/restaurant_repository.dart';

class GetRestaurantsUseCase {
  final RestaurantRepository repository;

  GetRestaurantsUseCase({required this.repository});

  Future<List<RestaurantModel>> execute() async {
    try {
      return await repository.getRestaurants();
    } catch (e) {
      throw Exception('UseCase error: $e');
    }
  }
}