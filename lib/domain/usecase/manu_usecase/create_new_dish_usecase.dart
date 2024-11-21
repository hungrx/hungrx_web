import 'package:hungrx_web/data/models/menu_models/dish_model.dart';
import 'package:hungrx_web/data/repositories/menu_repo/dish_repository.dart';

class CreateNewDishUseCase {
  final DishRepository _repository;

  CreateNewDishUseCase(this._repository);

  Future<Map<String, dynamic>> execute(DishModel dish) async {
    return await _repository.createNewDish(dish);
  }
}