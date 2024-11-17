import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/data/repositories/menu_repo/get_dropdown_menu_categories.dart';
import 'package:hungrx_web/presentation/bloc/dropdown_menu_category/dropdown_menu_category_event.dart';
import 'package:hungrx_web/presentation/bloc/dropdown_menu_category/dropdown_menu_category_state.dart';

class DropdownMenuCategoryBloc
    extends Bloc<DropdownMenuCategoryEvent, DropdownMenuCategoryState> {
  final GetDropdownMenuCategories getDropdownMenuCategories;

  DropdownMenuCategoryBloc({required this.getDropdownMenuCategories})
      : super(DropdownMenuCategoryInitial()) {
    on<FetchDropdownMenuCategories>(_onFetchDropdownMenuCategories);
  }

  Future<void> _onFetchDropdownMenuCategories(
    FetchDropdownMenuCategories event,
    Emitter<DropdownMenuCategoryState> emit,
  ) async {
    emit(DropdownMenuCategoryLoading());
    try {
      final response = await getDropdownMenuCategories.execute(event.restaurantId);
      emit(DropdownMenuCategoryLoaded(categories: response.menuCategories));
    } catch (e) {
      emit(DropdownMenuCategoryError(message: e.toString()));
    }
  }
}