class AddCategoryRequest {
  final String name;

  AddCategoryRequest({required this.name});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}