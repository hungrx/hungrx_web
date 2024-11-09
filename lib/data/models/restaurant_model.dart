class RestaurantModel {
  final String id;
  final String name;
  final String logo;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      logo: json['logo'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'logo': logo,
  };
}