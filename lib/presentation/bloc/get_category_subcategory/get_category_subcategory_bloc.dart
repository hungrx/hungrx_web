import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/domain/usecase/manu_usecase/get_categories_and_subcategories.dart';
import 'package:hungrx_web/presentation/bloc/get_category_subcategory/get_category_subcategory_event.dart';
import 'package:hungrx_web/presentation/bloc/get_category_subcategory/get_category_subcategory_state.dart';

class GetCategorySubcategoryBloc
    extends Bloc<GetCategorySubcategoryEvent, GetCategorySubcategoryState> {
  final GetCategoriesAndSubcategories getCategoriesAndSubcategories;

  GetCategorySubcategoryBloc({required this.getCategoriesAndSubcategories})
      : super(GetCategorySubcategoryInitial()) {
    on<FetchCategoriesAndSubcategoriesEvent>(_onFetchCategories);
  }

  Future<void> _onFetchCategories(
    FetchCategoriesAndSubcategoriesEvent event,
    Emitter<GetCategorySubcategoryState> emit,
  ) async {
    emit(GetCategorySubcategoryLoading());
    try {
      final response =
          await getCategoriesAndSubcategories.execute(event.restaurantId);
      emit(GetCategorySubcategoryLoaded(
          categories: response.restaurant.menuCategories));
    } catch (e) {
      emit(GetCategorySubcategoryError(message: e.toString()));
    }
  }
}