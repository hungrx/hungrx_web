import 'package:hungrx_web/core/error/menu_exceptions.dart';
import 'package:hungrx_web/data/datasource/api/menu_category_api_service.dart';
import 'package:hungrx_web/data/models/api_response_model.dart';
import 'package:hungrx_web/data/models/menu_category_model.dart';
import 'package:hungrx_web/data/repositories/menu_category_repository.dart';

class MenuRepositoryImpl implements MenuCategoryRepository {
  final MenuApiService apiService;

  MenuRepositoryImpl({required this.apiService});

  @override
  Future<ApiResponseModel<MenuCategoryModel>> createCategory(String name) async {
    try {
      final response = await apiService.createCategory(name);
      return ApiResponseModel.fromJson(
        response,
        (json) => MenuCategoryModel.fromJson(json),
      );
    } catch (e) {
      throw MenuException(e.toString());
    }
  }
}