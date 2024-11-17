abstract class GetCategorySubcategoryEvent {}

class FetchCategoriesAndSubcategoriesEvent extends GetCategorySubcategoryEvent {
  final String restaurantId;

  FetchCategoriesAndSubcategoriesEvent({required this.restaurantId});
}