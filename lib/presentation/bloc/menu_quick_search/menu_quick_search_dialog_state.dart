import 'package:hungrx_web/data/models/menu_models/quick_search_response.dart';

abstract class QuickSearchState {}

class QuickSearchInitial extends QuickSearchState {}

class QuickSearchLoading extends QuickSearchState {}

class QuickSearchSuccess extends QuickSearchState {
  final List<DishItem> dishes;

  QuickSearchSuccess({required this.dishes});
}

class QuickSearchError extends QuickSearchState {
  final String message;

  QuickSearchError({required this.message});
}