import 'package:hungrx_web/data/models/menu_models/get_category_subcategory_model.dart';

abstract class GetCategorySubcategoryState {}

class GetCategorySubcategoryInitial extends GetCategorySubcategoryState {}

class GetCategorySubcategoryLoading extends GetCategorySubcategoryState {}

class GetCategorySubcategoryLoaded extends GetCategorySubcategoryState {
  final List<MenuCategory> categories;

  GetCategorySubcategoryLoaded({required this.categories});
}

class GetCategorySubcategoryError extends GetCategorySubcategoryState {
  final String message;

  GetCategorySubcategoryError({required this.message});
}