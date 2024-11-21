class EditCategoryResponse {
  final bool status;
  final String message;
  final CategoryData category;

  EditCategoryResponse({
    required this.status,
    required this.message,
    required this.category,
  });

  factory EditCategoryResponse.fromJson(Map<String, dynamic> json) {
    return EditCategoryResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      category: CategoryData.fromJson(json['category'] ?? {}),
    );
  }
}

class CategoryData {
  final String id;
  final String name;
  final String updatedAt;

  CategoryData({
    required this.id,
    required this.name,
    required this.updatedAt,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}