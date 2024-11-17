import 'package:hungrx_web/data/models/menu_models/add_menu_subcategory_model.dart';

abstract class AddMenuSubcategoryState {}

class AddMenuSubcategoryInitial extends AddMenuSubcategoryState {}

class AddMenuSubcategoryLoading extends AddMenuSubcategoryState {}

class AddMenuSubcategorySuccess extends AddMenuSubcategoryState {
  final String message;
  final AddMenuSubcategoryData subcategory;

  AddMenuSubcategorySuccess({
    required this.message,
    required this.subcategory,
  });
}

class AddMenuSubcategoryError extends AddMenuSubcategoryState {
  final String message;

  AddMenuSubcategoryError({required this.message});
}