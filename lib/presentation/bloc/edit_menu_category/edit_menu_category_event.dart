abstract class EditCategoryEvent {}

class EditCategorySubmitted extends EditCategoryEvent {
  final String categoryId;
  final String restaurantId;
  final String name;

  EditCategorySubmitted({
    required this.categoryId,
    required this.restaurantId,
    required this.name,
  });
}
