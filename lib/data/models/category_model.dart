class CategoryModel {
  final String id;
  final String? name;

  CategoryModel({required this.id,  this.name});

factory CategoryModel.fromJson(dynamic json) {
    // Handle case where json is just the category ID string
    if (json is String) {
      return CategoryModel(id: json, name: '');
    }
    
    // Handle case where json is a Map containing category details
    if (json is Map<String, dynamic>) {
      return CategoryModel(
        id: json['_id']?.toString() ?? '',
        name: json['name']?.toString(),
      );
    }

    throw Exception('Invalid category data format');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}