abstract class AddFoodCategoryState {}

class AddFoodCategoryInitial extends AddFoodCategoryState {}

class AddFoodCategoryLoading extends AddFoodCategoryState {}

class AddFoodCategorySuccess extends AddFoodCategoryState {
  final String message;

  AddFoodCategorySuccess(this.message);
}

class AddFoodCategoryError extends AddFoodCategoryState {
  final String message;

  AddFoodCategoryError(this.message);
}