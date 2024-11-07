import 'package:dartz/dartz.dart';
import 'package:hungrx_web/core/error/failures.dart';
import 'package:hungrx_web/data/models/category_model.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryModel>>> getCategories();
}