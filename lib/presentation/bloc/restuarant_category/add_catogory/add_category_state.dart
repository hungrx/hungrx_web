abstract class AddCategoryState {}

class AddCategoryInitial extends AddCategoryState {}

class AddCategoryLoading extends AddCategoryState {}

class AddCategorySuccess extends AddCategoryState {
  final String message;

  AddCategorySuccess(this.message);
}

class AddCategoryFailure extends AddCategoryState {
  final String message;

  AddCategoryFailure(this.message);
}