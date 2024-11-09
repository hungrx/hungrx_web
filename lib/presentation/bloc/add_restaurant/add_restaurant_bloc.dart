import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/domain/usecase/add_restaurant_usecase.dart';
import 'package:hungrx_web/presentation/bloc/add_restaurant/add_restaurant_event.dart';
import 'package:hungrx_web/presentation/bloc/add_restaurant/add_restaurant_state.dart';

class AddRestaurantBloc extends Bloc<AddRestaurantEvent, AddRestaurantState> {
  final AddRestaurantUseCase _addRestaurantUseCase;

  AddRestaurantBloc({AddRestaurantUseCase? addRestaurantUseCase})
      : _addRestaurantUseCase = addRestaurantUseCase ?? AddRestaurantUseCase(),
        super(AddRestaurantInitial()) {
    on<AddRestaurantSubmitted>(_onAddRestaurantSubmitted);
  }

  Future<void> _onAddRestaurantSubmitted(
    AddRestaurantSubmitted event,
    Emitter<AddRestaurantState> emit,
  ) async {
    emit(AddRestaurantLoading());

    try {
      final response = await _addRestaurantUseCase.execute(event.restaurant);
      emit(AddRestaurantSuccess(response));
    } catch (e) {
      emit(AddRestaurantError(e.toString()));
    }
  }
}