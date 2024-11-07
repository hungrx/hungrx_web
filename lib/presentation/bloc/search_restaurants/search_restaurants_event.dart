abstract class SearchRestaurantEvent {}

class SearchRestaurantSubmitted extends SearchRestaurantEvent {
  final String query;
  SearchRestaurantSubmitted(this.query);
}

class ClearSearchResults extends SearchRestaurantEvent {}