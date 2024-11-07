import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/domain/usecase/search_restaurants_usecase.dart';
import 'package:hungrx_web/presentation/bloc/search_restaurants/search_restaurants_event.dart';
import 'package:hungrx_web/presentation/bloc/search_restaurants/search_restaurants_state.dart';

class SearchRestaurantBloc extends Bloc<SearchRestaurantEvent, SearchRestaurantState> {
  final SearchRestaurantsUseCase _searchRestaurantsUseCase;

  SearchRestaurantBloc(this._searchRestaurantsUseCase)
      : super(SearchRestaurantInitial()) {
    on<SearchRestaurantSubmitted>(_onSearchSubmitted);
    on<ClearSearchResults>(_onClearResults);
  }

  Future<void> _onSearchSubmitted(
    SearchRestaurantSubmitted event,
    Emitter<SearchRestaurantState> emit,
  ) async {
    emit(SearchRestaurantLoading());

    try {
      final restaurants = await _searchRestaurantsUseCase.execute(event.query);
      emit(SearchRestaurantSuccess(restaurants, event.query));
    } catch (e) {
      emit(SearchRestaurantError(e.toString()));
    }
  }

  void _onClearResults(
    ClearSearchResults event,
    Emitter<SearchRestaurantState> emit,
  ) {
    emit(SearchRestaurantInitial());
  }
}