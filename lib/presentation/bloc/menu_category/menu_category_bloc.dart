import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/domain/usecase/create_menu_category_usecase.dart';
import 'package:hungrx_web/presentation/bloc/menu_category/menu_category_event.dart';
import 'package:hungrx_web/presentation/bloc/menu_category/menu_category_state.dart';

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
      final result = await createMenuCategoryUseCase.execute(event.name);
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
