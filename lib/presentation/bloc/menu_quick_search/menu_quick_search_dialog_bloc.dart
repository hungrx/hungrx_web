import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/data/repositories/menu_repo/quick_search_repository.dart';
import 'package:hungrx_web/presentation/bloc/menu_quick_search/menu_quick_search_dialog_event.dart';
import 'package:hungrx_web/presentation/bloc/menu_quick_search/menu_quick_search_dialog_state.dart';

class QuickSearchBloc extends Bloc<QuickSearchEvent, QuickSearchState> {
  final QuickSearchRepository repository;

  QuickSearchBloc({required this.repository}) : super(QuickSearchInitial()) {
    on<SearchDishesEvent>(_onSearchDishes);
  }

  Future<void> _onSearchDishes(
    SearchDishesEvent event,
    Emitter<QuickSearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(QuickSearchSuccess(dishes: const []));
      return;
    }

    emit(QuickSearchLoading());

    try {
      final dishes = await repository.searchDishes(
        event.query,
        event.restaurantId,
      );
      emit(QuickSearchSuccess(dishes: dishes));
    } catch (e) {
      emit(QuickSearchError(message: e.toString()));
    }
  }
}