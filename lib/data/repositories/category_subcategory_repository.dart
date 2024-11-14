import 'package:hungrx_web/data/datasource/api/category_subcategory_api.dart';
import 'package:hungrx_web/data/models/add_subcategory_response.dart';
import 'package:hungrx_web/data/models/menu_category_subcategory_response.dart';

class CategorySubcategoryRepository {
  final CategorySubcategoryApi api;

  CategorySubcategoryRepository({required this.api});

  Future<CategorySubcategoryResponse> getCategoriesAndSubcategories() async {
    try {
      return await api.getCategoriesAndSubcategories();
    } catch (e) {
      rethrow;
    }
  }
  Future<AddSubcategoryResponse> addMenuSubcategory(
    String categoryId,
    String name,
  ) async {
    try {
      return await api.addMenuSubcategory(categoryId, name);
    } catch (e) {
      rethrow;
    }
  }
}
