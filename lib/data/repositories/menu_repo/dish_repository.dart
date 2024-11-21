import 'package:hungrx_web/data/datasource/api/menu_api/dish_api_service.dart';
import 'package:hungrx_web/data/models/menu_models/dish_model.dart';

class DishRepository {
  final DishApiService _apiService;

  DishRepository(this._apiService);

  Future<Map<String, dynamic>> createNewDish(DishModel dish) async {
    try {
      return await _apiService.createNewDish(dish);
    } catch (e) {
      rethrow;
    }
  }
}