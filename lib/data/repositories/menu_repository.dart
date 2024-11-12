import 'package:hungrx_web/core/error/menu_exception.dart';
import 'package:hungrx_web/data/datasource/api/menu_api.dart';
import 'package:hungrx_web/data/models/menu_model.dart';

class MenuRepository {
  final MenuApi _api;

  MenuRepository(this._api);

  Future<MenuResponse> getMenu(String restaurantId) async {
    try {
      return await _api.getMenu(restaurantId);
    } on TimeoutException {
      throw ApiException('Request timed out. Please try again.');
    } on NotFoundException {
      throw ApiException('Restaurant not found.');
    } on ServerException {
      throw ApiException('Server error occurred. Please try again later.');
    } on FormatException catch (e) {
      throw ApiException('Data format error: ${e.message}');
    } on NetworkException {
      throw ApiException('Network error. Please check your connection.');
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }
}
