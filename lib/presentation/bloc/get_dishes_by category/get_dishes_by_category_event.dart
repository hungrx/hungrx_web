abstract class GetDishesByCategoryEvent {}

class FetchDishesByCategoryEvent extends GetDishesByCategoryEvent {
  final String restaurantId;
  final String categoryId;

  FetchDishesByCategoryEvent({
    required this.restaurantId,
    required this.categoryId,
  });
}
