import 'package:dartz/dartz.dart';
import 'package:hungrx_web/core/error/failures.dart';
import 'package:hungrx_web/data/models/restaurant_models/category_model.dart';

// restuarant get category repo
abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryModel>>> getCategories();
}