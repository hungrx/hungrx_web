import 'package:hungrx_web/data/models/menu_models/get_dishes_by_category_response.dart';

abstract class GetDishesByCategoryState {}

class GetDishesByCategoryInitial extends GetDishesByCategoryState {}

class GetDishesByCategoryLoading extends GetDishesByCategoryState {}

class GetDishesByCategoryLoaded extends GetDishesByCategoryState {
  final DishesByCategoryData data;

  GetDishesByCategoryLoaded(this.data);
}

class GetDishesByCategoryError extends GetDishesByCategoryState {
  final String message;

  GetDishesByCategoryError(this.message);
}