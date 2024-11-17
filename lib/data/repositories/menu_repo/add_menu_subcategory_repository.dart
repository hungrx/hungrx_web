import 'package:hungrx_web/data/datasource/api/menu_api/add_menu_subcategory_api.dart';
import 'package:hungrx_web/data/models/menu_models/add_menu_subcategory_model.dart';

class AddMenuSubcategoryRepository {
  final AddMenuSubcategoryApi api;

  AddMenuSubcategoryRepository({required this.api});

  Future<AddMenuSubcategoryResponse> createSubcategory(
      AddMenuSubcategoryRequest request) {
    return api.createSubcategory(request);
  }
}