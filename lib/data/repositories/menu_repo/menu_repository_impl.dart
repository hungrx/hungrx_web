import 'package:hungrx_web/core/error/menu_exceptions.dart';
import 'package:hungrx_web/data/datasource/api/menu_api/add_menu_category_api_service.dart';
import 'package:hungrx_web/data/models/api_response_model.dart';
import 'package:hungrx_web/data/models/menu_models/menu_category_model.dart';
import 'package:hungrx_web/data/repositories/menu_repo/menu_category_repository.dart';

// this repoimpl for create new category
class MenuCategoryRepositoryImpl implements MenuCategoryRepository {
  final MenuApiService apiService;

  MenuCategoryRepositoryImpl({required this.apiService});

  @override
  Future<ApiResponseModel<MenuCategoryModel>> createCategory(
    String restaurantId, 
    String name,
  ) async {
    try {
      final response = await apiService.createCategory(restaurantId, name);
      
      if (response['category'] == null) {  // Changed from 'data' to 'category'
        return ApiResponseModel<MenuCategoryModel>(
          status: false,
          message: 'Invalid response: missing category data',
        );
      }

      final category = MenuCategoryModel.fromJson(response['category']);  // Changed from 'data' to 'category'
      
      return ApiResponseModel<MenuCategoryModel>(
        status: response['status'] ?? true,
        message: response['message'] ?? 'Category created successfully',
        data: category,
      );
    } on MenuException catch (e) {
      return ApiResponseModel<MenuCategoryModel>(
        status: false,
        message: e.toString(),
      );
    } catch (e) {
      return ApiResponseModel<MenuCategoryModel>(
        status: false,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }
}