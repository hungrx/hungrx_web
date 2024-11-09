abstract class AddRestaurantState {}

class AddRestaurantInitial extends AddRestaurantState {}

class AddRestaurantLoading extends AddRestaurantState {}

class AddRestaurantSuccess extends AddRestaurantState {
  final Map<String, dynamic> response;

  AddRestaurantSuccess(this.response);
}

class AddRestaurantError extends AddRestaurantState {
  final String message;

  AddRestaurantError(this.message);
}