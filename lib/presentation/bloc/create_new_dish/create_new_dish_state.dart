abstract class CreateDishState {}

class CreateDishInitial extends CreateDishState {}

class CreateDishLoading extends CreateDishState {}

class CreateDishSuccess extends CreateDishState {
  final Map<String, dynamic> response;
  CreateDishSuccess(this.response);
}

class CreateDishFailure extends CreateDishState {
  final String error;
  CreateDishFailure(this.error);
}