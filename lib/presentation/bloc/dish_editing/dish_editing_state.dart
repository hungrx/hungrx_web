abstract class DishEditState {}

class DishEditInitial extends DishEditState {}

class DishEditLoading extends DishEditState {}

class DishEditSuccess extends DishEditState {
  final String message;
  DishEditSuccess({required this.message});
}

class DishEditFailure extends DishEditState {
  final String error;
  DishEditFailure({required this.error});
}
