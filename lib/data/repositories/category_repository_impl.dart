import 'package:dartz/dartz.dart';
import 'package:hungrx_web/core/error/failures.dart';
import 'package:hungrx_web/data/datasource/api/category_remote_data_source.dart';
import 'package:hungrx_web/data/models/category_model.dart';
import 'package:hungrx_web/data/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkFailure catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }
}