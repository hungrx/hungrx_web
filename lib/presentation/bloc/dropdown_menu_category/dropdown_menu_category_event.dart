abstract class DropdownMenuCategoryEvent {}

class FetchDropdownMenuCategories extends DropdownMenuCategoryEvent {
  final String restaurantId;

  FetchDropdownMenuCategories({required this.restaurantId});
}