

  import 'package:hungrx_web/data/models/get_menu_category_response.dart';

  abstract class GetMenuCategoryState {}

  class GetMenuCategoryInitial extends GetMenuCategoryState {}

  class GetMenuCategoryLoading extends GetMenuCategoryState {}

  class GetMenuCategoryLoaded extends GetMenuCategoryState {
    final List<GetMenuCategoryModel> categories;

    GetMenuCategoryLoaded(this.categories);
  }

  class GetMenuCategoryEmpty extends GetMenuCategoryState {
    final String message;

    GetMenuCategoryEmpty(this.message);
  }

  class GetMenuCategoryError extends GetMenuCategoryState {
    final String message;

    GetMenuCategoryError(this.message);
  }