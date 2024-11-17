
class MenuCategoryModel {
  final String id;
  final String name;  // Removed restaurantId as it's not in the response
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
    try {
      return MenuCategoryModel(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        subcategories: json['subcategories'] ?? [],
        createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
        updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
      );
    } catch (e) {
      throw FormatException('Failed to parse MenuCategoryModel: ${e.toString()}');
    }
  }
}