abstract class CategorySubcategoryEvent {}

class FetchCategoriesAndSubcategories extends CategorySubcategoryEvent {}

class AddSubcategory extends CategorySubcategoryEvent {
  final String categoryId;
  final String subcategoryName;

  AddSubcategory({
    required this.categoryId,
    required this.subcategoryName,
  });
}