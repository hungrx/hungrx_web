import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/core/error/exceptions.dart';
import 'package:hungrx_web/data/repositories/edit_restaurant_repository.dart';
import 'package:hungrx_web/presentation/bloc/edit_restaurant/edit_restaurant_event.dart';
import 'package:hungrx_web/presentation/bloc/edit_restaurant/edit_restaurant_state.dart';

class EditRestaurantBloc extends Bloc<EditRestaurantEvent, EditRestaurantState> {
  final _repository = EditRestaurantRepository();

  EditRestaurantBloc() : super(EditRestaurantInitialState()) {
    on<EditRestaurantSubmitEvent>(_onEditRestaurantSubmitted);
  }

  Future<void> _onEditRestaurantSubmitted(
    EditRestaurantSubmitEvent event,
    Emitter<EditRestaurantState> emit,
  ) async {
    emit(EditRestaurantLoadingState());

    try {
      final restaurant = await _repository.updateRestaurant(event.restaurant);
      emit(EditRestaurantSuccessState(restaurant));
    } on EditRestaurantServerException catch (e) {
      emit(EditRestaurantErrorState(e.message));
    } on EditRestaurantNetworkException catch (e) {
      emit(EditRestaurantErrorState(e.message));
    } catch (e) {
      emit(EditRestaurantErrorState('An unexpected error occurred'));
    }
  }
}