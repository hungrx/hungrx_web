import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/core/error/menu_exceptions.dart';
import 'package:hungrx_web/data/repositories/menu_search_repository.dart';
import 'package:hungrx_web/presentation/bloc/menu_search/menu_search_event.dart';
import 'package:hungrx_web/presentation/bloc/menu_search/menu_search_state.dart';


class MenuSearchBloc extends Bloc<MenuSearchEvent, MenuSearchState> {
  final MenuSearchRepository repository;

  MenuSearchBloc({required this.repository}) : super(MenuSearchInitial()) {
    on<MenuSearchQuerySubmitted>(_onQuerySubmitted);
  }

  Future<void> _onQuerySubmitted(
    MenuSearchQuerySubmitted event,
    Emitter<MenuSearchState> emit,
  ) async {
    emit(MenuSearchLoading());

    try {
      final response = await repository.searchMenu(
        query: event.query,
        restaurantId: event.restaurantId,
      );
      emit(MenuSearchSuccess(response: response));
    } on MenuException catch (e) {
      emit(MenuSearchError(message: e.message));
    } catch (e) {
      emit(MenuSearchError(message: 'An unexpected error occurred'));
    }
  }
}