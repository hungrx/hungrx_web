class QuickSearchResponse {
  final bool status;
  final QuickSearchData data;

  QuickSearchResponse({
    required this.status,
    required this.data,
  });

  factory QuickSearchResponse.fromJson(Map<String, dynamic> json) {
    return QuickSearchResponse(
      status: json['status'],
      data: QuickSearchData.fromJson(json['data']),
    );
  }
}

class QuickSearchData {
  final String query;
  final QuickSearchSuggestions suggestions;
  final RestaurantInfo restaurant;
  final int totalResults;

  QuickSearchData({
    required this.query,
    required this.suggestions,
    required this.restaurant,
    required this.totalResults,
  });

  factory QuickSearchData.fromJson(Map<String, dynamic> json) {
    return QuickSearchData(
      query: json['query'],
      suggestions: QuickSearchSuggestions.fromJson(json['suggestions']),
      restaurant: RestaurantInfo.fromJson(json['restaurant']),
      totalResults: json['totalResults'],
    );
  }
}

class QuickSearchSuggestions {
  final List<DishItem> dishes;

  QuickSearchSuggestions({required this.dishes});

  factory QuickSearchSuggestions.fromJson(Map<String, dynamic> json) {
    final dishList = (json['dish'] as List)
        .map((dish) => DishItem.fromJson(dish))
        .toList();
    return QuickSearchSuggestions(dishes: dishList);
  }
}

class DishItem {
  final String id;
  final String name;
  final String image;
  final String? menuName;
  final String? matchType;
  final String? category;
  final String? subcategory;
  final String type;

  DishItem({
    required this.id,
    required this.name,
     this.image="",
     this.menuName,
     this.matchType,
    this.category,
    this.subcategory,
    required this.type,
  });

  factory DishItem.fromJson(Map<String, dynamic> json) {
    return DishItem(
      id: json['id']??"unknown",
      name: json['name']??"unknown",
      image: json['image']??"",
      menuName: json['menuName']??"unknown",
      matchType: json['matchType']??"unknown",
      category: json['category'],
      subcategory: json['subcategory'],
      type: json['type']??"unknow",
    );
  }
}

class RestaurantInfo {
  final String? id;
  final String? name;
  final String? logo;

  RestaurantInfo({
     this.id,
     this.name,
     this.logo,
  });

  factory RestaurantInfo.fromJson(Map<String, dynamic> json) {
    return RestaurantInfo(
      id: json['_id']??"unknown",
      name: json['name']??"known",
      logo: json['logo']??"",
    );
  }
}