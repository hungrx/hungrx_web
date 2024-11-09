import 'package:dartz/dartz.dart';
import 'package:hungrx_web/core/error/failures.dart';
import 'package:hungrx_web/data/datasource/api/restaurant_api_service.dart';
import 'package:hungrx_web/data/models/restaurant_model.dart';

class RestaurantRepository {
  final RestaurantApiService _apiService;

  RestaurantRepository({RestaurantApiService? apiService})
      : _apiService = apiService ?? RestaurantApiService();

  Future<Either<Failure, List<RestaurantModel>>> getRestaurants() async {
    try {
      final restaurantData = await _apiService.getRestaurants();
      final restaurants = restaurantData
          .map((json) => RestaurantModel.fromJson(json))
          .toList();
      return Right(restaurants);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkFailure catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  Future<Either<Failure, void>> deleteRestaurant(String id) async {
    try {
      await _apiService.deleteRestaurant(id);
      return const Right(null);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkFailure catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }
}
