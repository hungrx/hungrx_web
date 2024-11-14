import 'package:hungrx_web/data/models/menu_category_subcategory_response.dart';

abstract class CategorySubcategoryState {}

class CategorySubcategoryInitial extends CategorySubcategoryState {}

class CategorySubcategoryLoading extends CategorySubcategoryState {}

class CategorySubcategoryLoaded extends CategorySubcategoryState {
  final List<Category> categories;

  CategorySubcategoryLoaded({required this.categories});
}

class CategorySubcategoryError extends CategorySubcategoryState {
  final String message;

  CategorySubcategoryError({required this.message});
}
class SubcategoryCreatedSuccess extends CategorySubcategoryState {
  final String message;
  final List<Category> updatedCategories;

  SubcategoryCreatedSuccess({
    required this.message,
    required this.updatedCategories,
  });
}