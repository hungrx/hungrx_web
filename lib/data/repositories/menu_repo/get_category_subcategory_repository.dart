import 'package:hungrx_web/data/datasource/api/menu_api/get_category_subcategory_api.dart';
import 'package:hungrx_web/data/models/menu_models/get_category_subcategory_model.dart';

class GetCategorySubcategoryRepository {
  final GetCategorySubcategoryApi api;

  GetCategorySubcategoryRepository({required this.api});

  Future<GetCategorySubcategoryResponse> getCategoriesAndSubcategories(
      String restaurantId) {
    return api.getCategoriesAndSubcategories(restaurantId);
  }
}
