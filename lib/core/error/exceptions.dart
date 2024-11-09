class EditRestaurantServerException implements Exception {
  final String message;
  EditRestaurantServerException(this.message);
}

class EditRestaurantNetworkException implements Exception {
  final String message;
  EditRestaurantNetworkException(this.message);
}