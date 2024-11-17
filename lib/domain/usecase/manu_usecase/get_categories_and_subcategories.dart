import 'package:hungrx_web/data/models/menu_models/get_category_subcategory_model.dart';
import 'package:hungrx_web/data/repositories/menu_repo/get_category_subcategory_repository.dart';

class GetCategoriesAndSubcategories {
  final GetCategorySubcategoryRepository repository;

  GetCategoriesAndSubcategories({required this.repository});

  Future<GetCategorySubcategoryResponse> execute(String restaurantId) {
    return repository.getCategoriesAndSubcategories(restaurantId);
  }
}