abstract class FoodSearchEvent {}

class SearchFoodEvent extends FoodSearchEvent {
  final String query;
  SearchFoodEvent({required this.query});
}