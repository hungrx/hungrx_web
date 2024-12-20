class CategoryModel {
  final String id;
  final String? name;

  CategoryModel({required this.id, this.name});

  factory CategoryModel.fromJson(dynamic json) {
    if (json is String) {
      return CategoryModel(id: json, name: '');
    }
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

class MenuInfo {
  final String id;
  final String name;

  MenuInfo({
    required this.id,
    required this.name,
  });

  factory MenuInfo.fromJson(Map<String, dynamic> json) {
    return MenuInfo(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
