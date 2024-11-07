import 'package:hungrx_web/data/models/search_restaurant_model.dart';

abstract class SearchRestaurantState {}

class SearchRestaurantInitial extends SearchRestaurantState {}

class SearchRestaurantLoading extends SearchRestaurantState {}

class SearchRestaurantSuccess extends SearchRestaurantState {
  final List<SearchRestaurantModel> restaurants;
  final String searchQuery;

  SearchRestaurantSuccess(this.restaurants, this.searchQuery);
}

class SearchRestaurantError extends SearchRestaurantState {
  final String message;
  SearchRestaurantError(this.message);
}