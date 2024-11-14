abstract class GetMenuCategoryEvent {}

class FetchMenuCategories extends GetMenuCategoryEvent {
  final String restaurantId;

  FetchMenuCategories(this.restaurantId);
}