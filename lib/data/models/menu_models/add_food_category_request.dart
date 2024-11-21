class AddFoodCategoryRequest {
  final String restaurantId;
  final String menuId;
  final String categoryId;
  final String dishId;
  final String? subcategoryId;

  AddFoodCategoryRequest({
    required this.restaurantId,
    required this.menuId,
    required this.categoryId,
    required this.dishId,
    this.subcategoryId,
  });

  Map<String, dynamic> toJson() => {
        'restaurantId': restaurantId,
        'menuId': menuId,
        'categoryId': categoryId,
        'dishId': dishId,
        if (subcategoryId != null) 'subcategoryId': subcategoryId,
      };
} 