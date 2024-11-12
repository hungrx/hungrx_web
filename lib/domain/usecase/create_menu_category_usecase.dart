import 'package:hungrx_web/data/models/api_response_model.dart';
import 'package:hungrx_web/data/models/menu_category_model.dart';
import 'package:hungrx_web/data/repositories/menu_category_repository.dart';

class CreateMenuCategoryUseCase {
  final MenuCategoryRepository repository;

  CreateMenuCategoryUseCase(this.repository);

  Future<ApiResponseModel<MenuCategoryModel>> execute(String name) {
    return repository.createCategory(name);
  }
}