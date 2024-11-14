import 'dart:typed_data';
import 'package:hungrx_web/core/error/exceptions.dart';
import 'package:hungrx_web/data/datasource/api/dish_edit_api.dart';


import 'package:hungrx_web/data/models/dish_edit_model.dart';

class DishEditRepository {
  final _api = DishEditApi();

  Future<DishEditModel> updateDish(
    DishEditModel dish,
    Uint8List? imageBytes,
    String? imageName,
  ) async {
    print('Repository: Starting updateDish');
    try {
      final response = await _api.updateDish(
        name: dish.name,
        price: dish.price,
        rating: dish.rating,
        description: dish.description,
        calories: dish.calories,
        carbs: dish.carbs,
        protein: dish.protein,
        fats: dish.fats,
        servingSize: dish.servingSize,
        servingUnit: dish.servingUnit,
        categoryId: dish.categoryId,
        restaurantId: dish.restaurantId,
        menuId: dish.menuId,
        dishId: dish.dishId,
        subcategoryId: dish.subcategoryId,
        imageBytes: imageBytes,
        imageName: imageName,
      );
      
      if (response['dish'] != null) {
        return DishEditModel.fromJson(response['dish']);
      } else {
        if (response['status'] == true) {
          return dish;
        }
        throw DishEditServerException('Invalid response format');
      }
    } on DishEditServerException {
      rethrow;
    } on DishEditNetworkException {
      rethrow;
    } catch (e) {
      throw DishEditServerException('Error updating dish: $e');
    }
  }
}
