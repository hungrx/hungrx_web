import 'package:hungrx_web/data/models/menu_models/dropdown_menu_category_model.dart';

abstract class DropdownMenuCategoryState {}

class DropdownMenuCategoryInitial extends DropdownMenuCategoryState {}

class DropdownMenuCategoryLoading extends DropdownMenuCategoryState {}

class DropdownMenuCategoryLoaded extends DropdownMenuCategoryState {
  final List<DropdownMenuCategory> categories;

  DropdownMenuCategoryLoaded({required this.categories});
}

class DropdownMenuCategoryError extends DropdownMenuCategoryState {
  final String message;

  DropdownMenuCategoryError({required this.message});
}