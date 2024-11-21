class EditCategoryRequest {
  final String categoryId;
  final String restaurantId;
  final String name;

  EditCategoryRequest({
    required this.categoryId,
    required this.restaurantId,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
    'categoryId': categoryId,
    'restaurantId': restaurantId,
    'name': name,
  };
}