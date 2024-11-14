class EditRestaurantServerException implements Exception {
  final String message;
  EditRestaurantServerException(this.message);
}

class EditRestaurantNetworkException implements Exception {
  final String message;
  EditRestaurantNetworkException(this.message);
}

class DishEditException implements Exception {
  final String message;
  DishEditException(this.message);
}

class DishEditServerException extends DishEditException {
  DishEditServerException(super.message);
}

class DishEditNetworkException extends DishEditException {
  DishEditNetworkException(super.message);
}