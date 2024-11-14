import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/data/repositories/get_menu_category_repository.dart';
import 'package:hungrx_web/presentation/bloc/get_menu_category/get_menu_category_event.dart';
import 'package:hungrx_web/presentation/bloc/get_menu_category/get_menu_category_state.dart';

class GetMenuCategoryBloc extends Bloc<GetMenuCategoryEvent, GetMenuCategoryState> {
  final GetMenuCategoryRepository repository;

  GetMenuCategoryBloc({required this.repository}) : super(GetMenuCategoryInitial()) {
    on<FetchMenuCategories>(_onFetchMenuCategories);
  }

  Future<void> _onFetchMenuCategories(
    FetchMenuCategories event,
    Emitter<GetMenuCategoryState> emit,
  ) async {
    emit(GetMenuCategoryLoading());
    try {
      final categoryData = await repository.getMenuCategories(event.restaurantId);
      if (categoryData.categories.isEmpty) {
        emit(GetMenuCategoryEmpty('No menu categories found'));
      } else {
        emit(GetMenuCategoryLoaded(categoryData.categories));
      }
    } on TimeoutException {
      emit(GetMenuCategoryError(
          'Request timed out. Please check your connection and try again.'));
    } on FormatException catch (e) {
      emit(GetMenuCategoryError('Invalid data format: ${e.message}'));
    } catch (e) {
      emit(GetMenuCategoryError(e.toString()));
    }
  }
}