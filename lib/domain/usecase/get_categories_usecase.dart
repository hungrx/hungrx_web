import 'package:dartz/dartz.dart';
import 'package:hungrx_web/core/error/failures.dart';
import 'package:hungrx_web/data/models/category_model.dart';
import 'package:hungrx_web/data/repositories/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<Either<Failure, List<CategoryModel>>> call() async {
    return await repository.getCategories();
  }
}