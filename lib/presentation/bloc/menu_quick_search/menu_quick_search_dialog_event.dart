abstract class QuickSearchEvent {}

class SearchDishesEvent extends QuickSearchEvent {
  final String query;
  final String restaurantId;

  SearchDishesEvent({
    required this.query,
    required this.restaurantId,
  });
}