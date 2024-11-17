import 'package:hungrx_web/data/models/menu_models/dropdown_menu_category_model.dart';
import 'package:hungrx_web/data/repositories/menu_repo/dropdown_menu_category_repository.dart';

class GetDropdownMenuCategories {
  final DropdownMenuCategoryRepository repository;

  GetDropdownMenuCategories({required this.repository});

  Future<DropdownMenuCategoryResponse> execute(String restaurantId) {
    return repository.getCategories(restaurantId);
  }
}