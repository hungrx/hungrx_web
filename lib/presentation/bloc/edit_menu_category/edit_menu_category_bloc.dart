import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/data/models/menu_models/edit_menu_category_request.dart';
import 'package:hungrx_web/domain/usecase/manu_usecase/edit_category_usecase.dart';
import 'package:hungrx_web/presentation/bloc/edit_menu_category/edit_menu_category_event.dart';
import 'package:hungrx_web/presentation/bloc/edit_menu_category/edit_menu_category_state.dart';

class EditCategoryBloc extends Bloc<EditCategoryEvent, EditCategoryState> {
  final EditCategoryUseCase _editCategoryUseCase;

  EditCategoryBloc(this._editCategoryUseCase) : super(EditCategoryInitial()) {
    on<EditCategorySubmitted>(_onEditCategorySubmitted);
  }

  Future<void> _onEditCategorySubmitted(
    EditCategorySubmitted event,
    Emitter<EditCategoryState> emit,
  ) async {
    emit(EditCategoryLoading());

    try {
      final request = EditCategoryRequest(
        categoryId: event.categoryId,
        restaurantId: event.restaurantId,
        name: event.name,
      );

      final response = await _editCategoryUseCase.execute(request);

      if (response.status) {
        emit(EditCategorySuccess(
          message: response.message,
          category: response.category,
        ));
      } else {
        emit(EditCategoryError(response.message));
      }
    } catch (e) {
      emit(EditCategoryError(e.toString()));
    }
  }
}