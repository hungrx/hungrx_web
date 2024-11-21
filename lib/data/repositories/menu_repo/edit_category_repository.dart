import 'package:hungrx_web/data/datasource/api/menu_api/edit_menu_category_api_service.dart';
import 'package:hungrx_web/data/models/menu_models/edit_menu_category_request.dart';
import 'package:hungrx_web/data/models/menu_models/edit_menu_category_response.dart';

class CategoryRepository {
  final CategoryApiService _apiService;

  CategoryRepository(this._apiService);

  Future<EditCategoryResponse> editCategory(EditCategoryRequest request) {
    return _apiService.editCategory(request);
  }
}
