import 'package:hungrx_web/data/models/menu_models/dish_model.dart';

abstract class CreateDishEvent {}

class CreateDishSubmitted extends CreateDishEvent {
  final DishModel dish;
  CreateDishSubmitted(this.dish);
}