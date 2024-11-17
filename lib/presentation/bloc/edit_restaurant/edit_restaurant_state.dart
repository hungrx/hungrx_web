import 'package:hungrx_web/data/models/restaurant_models/edit_restaurant_model.dart';

abstract class EditRestaurantState {}

class EditRestaurantInitialState extends EditRestaurantState {}

class EditRestaurantLoadingState extends EditRestaurantState {}

class EditRestaurantSuccessState extends EditRestaurantState {
  final EditRestaurantModel restaurant;
  EditRestaurantSuccessState(this.restaurant);
}

class EditRestaurantErrorState extends EditRestaurantState {
  final String message;
  EditRestaurantErrorState(this.message);
}