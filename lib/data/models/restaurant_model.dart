class RestaurantModel {
  final String name;
  final String logo;

  RestaurantModel({required this.name, required this.logo});

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      name: json['name'] as String,
      logo: json['logo'] as String,
    );
  }
}
