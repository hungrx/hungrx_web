import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/domain/usecase/get_categories_usecase.dart';
import 'package:hungrx_web/presentation/bloc/restuarant_category/restuarant_category_event.dart';
import 'package:hungrx_web/presentation/bloc/restuarant_category/restuarant_category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoriesUseCase getCategoriesUseCase;

  CategoryBloc({required this.getCategoriesUseCase}) : super(CategoryInitial()) {
    on<FetchCategories>(_onFetchCategories);
  }

  Future<void> _onFetchCategories(
    FetchCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    
    final result = await getCategoriesUseCase();
    
    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (categories) => emit(CategoryLoaded(categories)),
    );
  }
}