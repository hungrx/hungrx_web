import 'package:hungrx_web/data/datasource/api/menu_api/dropdown_menu_category_api.dart';
import 'package:hungrx_web/data/models/menu_models/dropdown_menu_category_model.dart';

class DropdownMenuCategoryRepository {
  final DropdownMenuCategoryApi api;

  DropdownMenuCategoryRepository({required this.api});

  Future<DropdownMenuCategoryResponse> getCategories(String restaurantId) {
    return api.getCategories(restaurantId);
  }
}