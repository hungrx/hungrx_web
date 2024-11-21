import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/domain/usecase/manu_usecase/create_new_dish_usecase.dart';
import 'package:hungrx_web/presentation/bloc/create_new_dish/create_new_dish_event.dart';
import 'package:hungrx_web/presentation/bloc/create_new_dish/create_new_dish_state.dart';

class CreateDishBloc extends Bloc<CreateDishEvent, CreateDishState> {
  final CreateNewDishUseCase _createNewDishUseCase;

  CreateDishBloc(this._createNewDishUseCase) : super(CreateDishInitial()) {
    on<CreateDishSubmitted>(_onCreateDishSubmitted);
  }

  Future<void> _onCreateDishSubmitted(
    CreateDishSubmitted event,
    Emitter<CreateDishState> emit,
  ) async {
    emit(CreateDishLoading());
    try {
      final response = await _createNewDishUseCase.execute(event.dish);
      emit(CreateDishSuccess(response));
    } catch (e) {
      emit(CreateDishFailure(e.toString()));
    }
  }
}
