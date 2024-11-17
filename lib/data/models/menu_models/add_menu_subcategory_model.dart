class AddMenuSubcategoryRequest {
  final String restaurantId;
  final String name;
  final String categoryId;

  AddMenuSubcategoryRequest({
    required this.restaurantId,
    required this.name,
    required this.categoryId,
  });

  Map<String, dynamic> toJson() => {
        'restaurantId': restaurantId,
        'name': name,
        'categoryId': categoryId,
      };
}

class AddMenuSubcategoryResponse {
  final bool status;
  final String message;
  final AddMenuSubcategoryData subcategory;

  AddMenuSubcategoryResponse({
    required this.status,
    required this.message,
    required this.subcategory,
  });

  factory AddMenuSubcategoryResponse.fromJson(Map<String, dynamic> json) {
    return AddMenuSubcategoryResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      subcategory: AddMenuSubcategoryData.fromJson(json['subcategory']),
    );
  }
}

class AddMenuSubcategoryData {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  AddMenuSubcategoryData({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddMenuSubcategoryData.fromJson(Map<String, dynamic> json) {
    return AddMenuSubcategoryData(
      id: json['_id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
