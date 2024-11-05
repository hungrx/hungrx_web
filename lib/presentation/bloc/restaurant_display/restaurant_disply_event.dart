import 'package:equatable/equatable.dart';

abstract class RestaurantEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchRestaurants extends RestaurantEvent {}

class SearchRestaurants extends RestaurantEvent {
  final String query;

  SearchRestaurants(this.query);

  @override
  List<Object> get props => [query];
}