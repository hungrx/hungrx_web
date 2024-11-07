class SearchRestaurantModel {
  final String id;
  final String name;
  final String logo;

  SearchRestaurantModel({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory SearchRestaurantModel.fromJson(Map<String, dynamic> json) {
    return SearchRestaurantModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
    );
  }
}
