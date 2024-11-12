
class MenuCategoryModel {
  final String id;
  final String name;
  final List<dynamic> subcategories;
  final DateTime createdAt;
  final DateTime updatedAt;

  MenuCategoryModel({
    required this.id,
    required this.name,
    required this.subcategories,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MenuCategoryModel.fromJson(Map<String, dynamic> json) {
    return MenuCategoryModel(
      id: json['_id'],
      name: json['name'],
      subcategories: json['subcategories'] ?? [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}