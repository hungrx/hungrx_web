class DropdownMenuCategory {
  final String id;
  final String name;

  DropdownMenuCategory({
    required this.id,
    required this.name,
  });

  factory DropdownMenuCategory.fromJson(Map<String, dynamic> json) {
    return DropdownMenuCategory(
      id: json['_id'] as String,
      name: json['name'] as String,
    );
  }
}

class DropdownMenuCategoryResponse {
  final bool status;
  final List<DropdownMenuCategory> menuCategories;

  DropdownMenuCategoryResponse({
    required this.status,
    required this.menuCategories,
  });

  factory DropdownMenuCategoryResponse.fromJson(Map<String, dynamic> json) {
    return DropdownMenuCategoryResponse(
      status: json['status'] as bool,
      menuCategories: (json['menuCategories'] as List)
          .map((category) => DropdownMenuCategory.fromJson(category))
          .toList(),
    );
  }
}