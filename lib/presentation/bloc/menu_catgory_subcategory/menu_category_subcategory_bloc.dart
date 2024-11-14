import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/data/models/menu_category_subcategory_response.dart';
import 'package:hungrx_web/data/repositories/category_subcategory_repository.dart';
import 'package:hungrx_web/presentation/bloc/menu_catgory_subcategory/menu_category_subcategory_event.dart';
import 'package:hungrx_web/presentation/bloc/menu_catgory_subcategory/menu_category_subcategory_state.dart';

class CategorySubcategoryBloc
    extends Bloc<CategorySubcategoryEvent, CategorySubcategoryState> {
  final CategorySubcategoryRepository repository;
List<Category> _categories = [];
  CategorySubcategoryBloc({required this.repository})
      : super(CategorySubcategoryInitial()) {
    on<FetchCategoriesAndSubcategories>(_onFetchCategoriesAndSubcategories);
    on<AddSubcategory>(_onAddSubcategory);
  }

  Future<void> _onFetchCategoriesAndSubcategories(
    FetchCategoriesAndSubcategories event,
    Emitter<CategorySubcategoryState> emit,
  ) async {
    emit(CategorySubcategoryLoading());
    try {
      final response = await repository.getCategoriesAndSubcategories();
       _categories = response.data.categories;
      emit(CategorySubcategoryLoaded(categories: _categories));
    } catch (e) {
      emit(CategorySubcategoryError(message: e.toString()));
    }
  }

  Future<void> _onAddSubcategory(
    AddSubcategory event,
    Emitter<CategorySubcategoryState> emit,
  ) async {
    try {
      emit(CategorySubcategoryLoading());
      
      final response = await repository.addMenuSubcategory(
        event.categoryId,
        event.subcategoryName,
      );

      // Update the categories list with the new subcategory
      _categories = _categories.map((category) {
        if (category.id == event.categoryId) {
          return response.category;
        }
        return category;
      }).toList();

      emit(SubcategoryCreatedSuccess(
        message: response.message,
        updatedCategories: _categories,
      ));
      
      // Emit loaded state with updated categories
      emit(CategorySubcategoryLoaded(categories: _categories));
    } catch (e) {
      emit(CategorySubcategoryError(message: e.toString()));
    }
  }
}