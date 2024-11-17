abstract class MenuCategoryEvent {}

class CreateMenuCategoryEvent extends MenuCategoryEvent {
  final String restaurantId;
  final String name;

  CreateMenuCategoryEvent(this.restaurantId, this.name);
}