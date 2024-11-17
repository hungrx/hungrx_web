import 'package:hungrx_web/data/models/menu_models/add_menu_subcategory_model.dart';
import 'package:hungrx_web/data/repositories/menu_repo/add_menu_subcategory_repository.dart';

class CreateMenuSubcategory {
  final AddMenuSubcategoryRepository repository;

  CreateMenuSubcategory({required this.repository});

  Future<AddMenuSubcategoryResponse> execute(AddMenuSubcategoryRequest request) {
    return repository.createSubcategory(request);
  }
}