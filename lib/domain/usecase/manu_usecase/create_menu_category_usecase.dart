import 'package:hungrx_web/data/models/api_response_model.dart';
import 'package:hungrx_web/data/models/menu_models/menu_category_model.dart';
import 'package:hungrx_web/data/repositories/menu_repo/menu_category_repository.dart';

// create menu category usecase
class CreateMenuCategoryUseCase {
  final MenuCategoryRepository repository;

  CreateMenuCategoryUseCase(this.repository);

  Future<ApiResponseModel<MenuCategoryModel>> execute(String restaurantId, String name) {
    return repository.createCategory(restaurantId, name);
  }
}