import 'package:dartz/dartz.dart';
import 'package:hungrx_web/core/error/failures.dart';
import 'package:hungrx_web/data/models/restaurant_models/restaurant_model.dart';
import 'package:hungrx_web/data/repositories/restaurant_repo/restaurant_repository.dart';

class GetRestaurantsUseCase {
  final RestaurantRepository repository;

  GetRestaurantsUseCase({required this.repository});

  Future<Either<Failure, List<RestaurantModel>>> execute() async {
    return await repository.getRestaurants();
  }
}