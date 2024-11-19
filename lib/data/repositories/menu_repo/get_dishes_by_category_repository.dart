import 'package:hungrx_web/data/datasource/api/menu_api/get_dishes_by_category_api.dart';
import 'package:hungrx_web/data/models/menu_models/get_dishes_by_category_response.dart';

class GetDishesByCategoryRepository {
  final GetDishesByCategoryApi _api;

  GetDishesByCategoryRepository({
    GetDishesByCategoryApi? api,
  }) : _api = api ?? GetDishesByCategoryApi();

  Future<GetDishesByCategoryResponse> getDishesByCategory({
    required String restaurantId,
    required String categoryId,
  }) async {
    try {
      final json = await _api.getDishesByCategory(
        restaurantId: restaurantId,
        categoryId: categoryId,
      );
      return GetDishesByCategoryResponse.fromJson(json);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}