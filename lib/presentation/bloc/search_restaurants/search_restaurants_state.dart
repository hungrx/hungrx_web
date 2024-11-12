import 'package:hungrx_web/data/models/search_restaurant_model.dart';

abstract class SearchRestaurantState {
  final String searchQuery;
  
  SearchRestaurantState(this.searchQuery);
}

class SearchRestaurantInitial extends SearchRestaurantState {
  SearchRestaurantInitial() : super('');
}

class SearchRestaurantLoading extends SearchRestaurantState {
  SearchRestaurantLoading(super.searchQuery);
}

class SearchRestaurantSuccess extends SearchRestaurantState {
  final List<SearchRestaurantModel> restaurants;

  SearchRestaurantSuccess(this.restaurants, String searchQuery) 
      : super(searchQuery);
}

class SearchRestaurantError extends SearchRestaurantState {
  final String message;

  SearchRestaurantError(this.message, String searchQuery) 
      : super(searchQuery);
}
