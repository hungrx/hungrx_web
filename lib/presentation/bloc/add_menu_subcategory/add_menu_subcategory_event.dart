abstract class AddMenuSubcategoryEvent {}

class CreateAddMenuSubcategory extends AddMenuSubcategoryEvent {
  final String restaurantId;
  final String name;
  final String categoryId;

  CreateAddMenuSubcategory({
    required this.restaurantId,
    required this.name,
    required this.categoryId,
  });
}