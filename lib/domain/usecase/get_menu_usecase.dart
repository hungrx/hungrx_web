import 'package:hungrx_web/data/models/menu_model.dart';
import 'package:hungrx_web/data/repositories/menu_repository.dart';

class GetMenuUseCase {
  final MenuRepository _repository;

  GetMenuUseCase(this._repository);

  Future<MenuResponse> execute(String restaurantId) async {
    try {
      return await _repository.getMenu(restaurantId);
    } catch (e) {
      print(e);
      throw Exception('UseCase error: $e');
    }
  }
}