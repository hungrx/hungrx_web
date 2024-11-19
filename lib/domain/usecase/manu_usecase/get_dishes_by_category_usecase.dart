import 'package:hungrx_web/data/models/menu_models/get_dishes_by_category_response.dart';
import 'package:hungrx_web/data/repositories/menu_repo/get_dishes_by_category_repository.dart';

class GetDishesByCategoryUseCase {
  final GetDishesByCategoryRepository _repository;

  GetDishesByCategoryUseCase({
    GetDishesByCategoryRepository? repository,
  }) : _repository = repository ?? GetDishesByCategoryRepository();

  Future<GetDishesByCategoryResponse> execute({
    required String restaurantId,
    required String categoryId,
  }) async {
    return await _repository.getDishesByCategory(
      restaurantId: restaurantId,
      categoryId: categoryId,
    );
  }
}