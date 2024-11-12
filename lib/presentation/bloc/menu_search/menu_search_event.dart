abstract class MenuSearchEvent {}

class MenuSearchQuerySubmitted extends MenuSearchEvent {
  final String query;
  final String restaurantId;

  MenuSearchQuerySubmitted({
    required this.query,
    required this.restaurantId,
  });
}