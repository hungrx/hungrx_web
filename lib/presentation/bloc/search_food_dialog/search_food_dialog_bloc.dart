import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/data/repositories/menu_repo/food_search_repo.dart';
import 'package:hungrx_web/presentation/bloc/search_food_dialog/search_food_dialog_event.dart';
import 'package:hungrx_web/presentation/bloc/search_food_dialog/search_food_dialog_state.dart';

class FoodSearchBloc extends Bloc<FoodSearchEvent, FoodSearchState> {
  final FoodRepository foodRepository;

  FoodSearchBloc({required this.foodRepository}) : super(FoodSearchInitial()) {
    on<SearchFoodEvent>(_onSearchFood);
  }

  Future<void> _onSearchFood(
    SearchFoodEvent event,
    Emitter<FoodSearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(FoodSearchSuccess(foods: const []));
      return;
    }

    emit(FoodSearchLoading());

    try {
      final foods = await foodRepository.searchFoods(event.query);
      emit(FoodSearchSuccess(foods: foods));
    } catch (e) {
      emit(FoodSearchError(message: e.toString()));
    }
  }
}