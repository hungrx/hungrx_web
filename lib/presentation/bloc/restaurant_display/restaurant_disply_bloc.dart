import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/domain/usecase/get_restaurants_usecase.dart';
import 'package:hungrx_web/presentation/bloc/restaurant_display/restaurant_disply_event.dart';
import 'package:hungrx_web/presentation/bloc/restaurant_display/restaurant_disply_state.dart';


class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final GetRestaurantsUseCase getRestaurantsUseCase;


  RestaurantBloc({
    required this.getRestaurantsUseCase,
    
  }) : super(RestaurantInitial()) {
    on<FetchRestaurants>(_onFetchRestaurants);
    on<SearchRestaurants>(_onSearchRestaurants);

  }

  Future<void> _onFetchRestaurants(
    FetchRestaurants event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(RestaurantLoading());
    final result = await getRestaurantsUseCase.execute();
    result.fold(
      (failure) => emit(RestaurantError(failure.message)),
      (restaurants) => emit(RestaurantLoaded(restaurants)),
    );
  }

  Future<void> _onSearchRestaurants(
    SearchRestaurants event,
    Emitter<RestaurantState> emit,
  ) async {
    if (state is RestaurantLoaded) {
      final currentRestaurants = (state as RestaurantLoaded).restaurants;
      final filteredRestaurants = currentRestaurants
          .where((restaurant) =>
              restaurant.name.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(RestaurantLoaded(filteredRestaurants));
    }
  }
}