import 'package:hungrx_web/data/datasource/api/menu_api/add_food_category_api.dart';
import 'package:hungrx_web/data/models/menu_models/add_food_category_request.dart';
import 'package:hungrx_web/data/models/menu_models/add_food_category_response.dart';

class AddFoodCategoryRepository {
  final AddFoodCategoryApi api;

  AddFoodCategoryRepository({required this.api});

  Future<AddFoodCategoryResponse> addFoodToCategory(AddFoodCategoryRequest request) {
    return api.addFoodToCategory(request);
  }
}