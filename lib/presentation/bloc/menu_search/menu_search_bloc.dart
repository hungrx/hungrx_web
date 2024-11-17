import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/core/error/menu_exceptions.dart';
import 'package:hungrx_web/data/repositories/menu_repo/menu_search_repository.dart';
import 'package:hungrx_web/presentation/bloc/menu_search/menu_search_event.dart';
import 'package:hungrx_web/presentation/bloc/menu_search/menu_search_state.dart';


class MenuSearchBloc extends Bloc<MenuSearchEvent, MenuSearchState> {
  final MenuSearchRepository repository;

  MenuSearchBloc({required this.repository}) : super(MenuSearchInitial()) {
    on<MenuSearchQuerySubmitted>(_onSearchQuerySubmitted);
  }

  Future<void> _onSearchQuerySubmitted(
    MenuSearchQuerySubmitted event,
    Emitter<MenuSearchState> emit,
  ) async { 
    if (event.query.trim().isEmpty) {
      emit(MenuSearchError(message: 'Please enter a search term'));
      return;
    }

    emit(MenuSearchLoading());

    try {
      final response = await repository.searchMenu(
        query: event.query.trim(),
        restaurantId: event.restaurantId,
      );
          debugPrint('Search Response - Restaurant: ${response.data.restaurant.name}');
      debugPrint('Results length: ${response.data.results.length}');
      debugPrint('Total Results: ${response.data.totalResults}');

       if (response.data.categories != null && response.data.results.isEmpty) {
        emit(MenuSearchEmpty(message: 'No menu items found for this search'));
        return;
      }

      // Check if we have valid results
      if (!response.data.hasValidResults()) {
        emit(MenuSearchEmpty(
          message: 'No dishes found matching "${event.query}" in ${response.data.restaurant.name}',
        ));
        return;
      }

      emit(MenuSearchSuccess(response: response));
    } on MenuException catch (e) {
      emit(MenuSearchError(message: e.message));
    } catch (e) {
      emit(MenuSearchError(message: 'An unexpected error occurred. Please try again.'));
    }
  }
}