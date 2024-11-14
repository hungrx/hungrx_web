import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/data/repositories/dish_edit_repository.dart';
import 'package:hungrx_web/presentation/bloc/dish_editing/dish_editing_event.dart';
import 'package:hungrx_web/presentation/bloc/dish_editing/dish_editing_state.dart';

class DishEditBloc extends Bloc<DishEditEvent, DishEditState> {
  final DishEditRepository repository;

  DishEditBloc({required this.repository}) : super(DishEditInitial()) {
    on<DishEditSubmitted>(_onDishEditSubmitted);
  }

  Future<void> _onDishEditSubmitted(
    DishEditSubmitted event,
    Emitter<DishEditState> emit,
  ) async {
    emit(DishEditLoading());
    try {
       print('Processing DishEditSubmitted event');
      await repository.updateDish(
        event.dish,
        event.imageBytes,
        event.imageName,
      );
      print('Dish updated successfully');
      emit(DishEditSuccess(message: 'Dish updated successfully'));
    } catch (e) {
      emit(DishEditFailure(error: e.toString()));
    }
  }
}
