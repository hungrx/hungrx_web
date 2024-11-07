import 'package:dartz/dartz.dart';
import 'package:hungrx_web/core/error/failures.dart';
import 'package:hungrx_web/data/datasource/api/add_category_remote_data_source.dart';
import 'package:hungrx_web/data/models/add_category_model.dart';
import 'package:hungrx_web/data/models/add_category_response.dart';

class AddCategoryRepository {
  final AddCategoryDataSource dataSource;

  AddCategoryRepository({required this.dataSource});

  Future<Either<Failure, AddCategoryResponse>> addCategory(String name) async {
    try {
      final request = AddCategoryRequest(name: name);
      final response = await dataSource.addCategory(request);
      return Right(response);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkFailure catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }
}