

import 'package:hungrx_web/data/models/menu_models/menu_search_response.dart';

abstract class MenuSearchState {}

class MenuSearchInitial extends MenuSearchState {}

class MenuSearchLoading extends MenuSearchState {}

class MenuSearchSuccess extends MenuSearchState {
  final MenuSearchResponse response;

  MenuSearchSuccess({required this.response});
}

class MenuSearchEmpty extends MenuSearchState {
  final String message;

  MenuSearchEmpty({this.message = 'No results found'});
}

class MenuSearchError extends MenuSearchState {
  final String message;

  MenuSearchError({required this.message});
}