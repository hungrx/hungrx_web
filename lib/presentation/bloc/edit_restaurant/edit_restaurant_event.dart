import 'package:hungrx_web/data/models/edit_restaurant_model.dart';

abstract class EditRestaurantEvent {}

class EditRestaurantSubmitEvent extends EditRestaurantEvent {
  final String restaurantId;
  final EditRestaurantModel restaurant;

  EditRestaurantSubmitEvent({
    required this.restaurantId,
    required this.restaurant,
  });
}