abstract class AddFoodCategoryEvent {}

class AddFoodToCategoryEvent extends AddFoodCategoryEvent {
  final String restaurantId;
  final String menuId;
  final String categoryId;
  final String dishId;
  final String? subcategoryId;

  AddFoodToCategoryEvent({
    required this.restaurantId,
    required this.menuId,
    required this.categoryId,
    required this.dishId,
    this.subcategoryId,
  });
}