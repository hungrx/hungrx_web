import 'package:hungrx_web/data/models/api_response_model.dart';
import 'package:hungrx_web/data/models/menu_category_model.dart';

abstract class MenuCategoryRepository {
  Future<ApiResponseModel<MenuCategoryModel>> createCategory(String name);
}