import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/domain/usecase/manu_usecase/create_menu_category_usecase.dart';
import 'package:hungrx_web/presentation/bloc/add_menu_main_category/menu_category_event.dart';
import 'package:hungrx_web/presentation/bloc/add_menu_main_category/menu_category_state.dart';

// this bloc is for create new main category
class MenuCategoryBloc extends Bloc<MenuCategoryEvent, MenuCategoryState> {
  final CreateMenuCategoryUseCase createMenuCategoryUseCase;

  MenuCategoryBloc({required this.createMenuCategoryUseCase}) : super(MenuCategoryInitial()) {
    on<CreateMenuCategoryEvent>(_handleCreateCategory);
  }

  Future<void> _handleCreateCategory(
    CreateMenuCategoryEvent event,
    Emitter<MenuCategoryState> emit,
  ) async {
    emit(MenuCategoryLoading());
    try {
      final result = await createMenuCategoryUseCase.execute(
        event.restaurantId,
        event.name,
      );
      if (result.status && result.data != null) {
        emit(MenuCategoryCreatedSuccess(result.message, result.data!));
      } else {
        emit(MenuCategoryError(result.message));
      }
    } catch (e) {
      emit(MenuCategoryError(e.toString()));
    }
  }
}