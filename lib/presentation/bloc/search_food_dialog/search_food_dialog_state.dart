import 'package:hungrx_web/data/models/menu_models/search_food_model.dart';

abstract class FoodSearchState {}

class FoodSearchInitial extends FoodSearchState {}

class FoodSearchLoading extends FoodSearchState {}

class FoodSearchSuccess extends FoodSearchState {
  final List<Food> foods;
  FoodSearchSuccess({required this.foods});
}

class FoodSearchError extends FoodSearchState {
  final String message;
  FoodSearchError({required this.message});
}