import 'package:hungrx_web/data/models/menu_models/edit_menu_category_response.dart';

abstract class EditCategoryState {}

class EditCategoryInitial extends EditCategoryState {}

class EditCategoryLoading extends EditCategoryState {}

class EditCategorySuccess extends EditCategoryState {
  final String message;
  final CategoryData category;

  EditCategorySuccess({required this.message, required this.category});
}

class EditCategoryError extends EditCategoryState {
  final String error;

  EditCategoryError(this.error);
}