import 'package:hungrx_web/data/models/menu_models/edit_menu_category_request.dart';
import 'package:hungrx_web/data/models/menu_models/edit_menu_category_response.dart';
import 'package:hungrx_web/data/repositories/menu_repo/edit_category_repository.dart';

class EditCategoryUseCase {
  final CategoryRepository _repository;

  EditCategoryUseCase(this._repository);

  Future<EditCategoryResponse> execute(EditCategoryRequest request) {
    return _repository.editCategory(request);
  }
}