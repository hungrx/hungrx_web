import 'package:hungrx_web/data/models/menu_models/menu_category_model.dart';

abstract class MenuCategoryState {}

class MenuCategoryInitial extends MenuCategoryState {}

class MenuCategoryLoading extends MenuCategoryState {}

class MenuCategoryCreatedSuccess extends MenuCategoryState {
  final String message;
  final MenuCategoryModel category;

  MenuCategoryCreatedSuccess(this.message, this.category);
}

class MenuCategoryError extends MenuCategoryState {
  final String message;

  MenuCategoryError(this.message);
}