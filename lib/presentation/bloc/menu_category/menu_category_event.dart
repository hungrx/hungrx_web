abstract class MenuCategoryEvent {}

class CreateMenuCategoryEvent extends MenuCategoryEvent {
  final String name;

  CreateMenuCategoryEvent(this.name);
}