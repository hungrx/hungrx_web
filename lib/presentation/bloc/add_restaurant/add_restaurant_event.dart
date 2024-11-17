import 'package:hungrx_web/data/models/restaurant_models/add_restaurant_model.dart';

abstract class AddRestaurantEvent {}

class AddRestaurantSubmitted extends AddRestaurantEvent {
  final AddRestaurantModel restaurant;

  AddRestaurantSubmitted({required this.restaurant});
}

