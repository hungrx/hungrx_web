import 'package:hungrx_web/data/models/menu_models/get_menu_category_response.dart';
import 'package:hungrx_web/data/models/menu_models/menu_model.dart';
import 'package:hungrx_web/data/models/restaurant_models/category_model.dart';
import 'package:hungrx_web/data/models/restaurant_models/search_restaurant_model.dart';

class GetDishesByCategoryResponse {
  final bool status;
  final String message;
  final int count;
  final DishesByCategoryData data;

  GetDishesByCategoryResponse({
    required this.status,
    required this.message,
    required this.count,
    required this.data,
  });

  factory GetDishesByCategoryResponse.fromJson(Map<String, dynamic> json) {
    return GetDishesByCategoryResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      count: json['count'] ?? 0,
      data: DishesByCategoryData.fromJson(json['data'] ?? {}),
    );
  }
}

class DishesByCategoryData {
  final RestaurantInfo restaurantInfo;
  final MenuInfo menuInfo;
  final CategoryInfo categoryInfo;
  final List<Dish> dishes;

  DishesByCategoryData({
    required this.restaurantInfo,
    required this.menuInfo,
    required this.categoryInfo,
    required this.dishes,
  });

  factory DishesByCategoryData.fromJson(Map<String, dynamic> json) {
    return DishesByCategoryData(
      restaurantInfo: RestaurantInfo.fromJson(json['restaurantInfo'] ?? {}),
      menuInfo: MenuInfo.fromJson(json['menuInfo'] ?? {}),
      categoryInfo: CategoryInfo.fromJson(json['categoryInfo'] ?? {}),
      dishes: (json['dishes'] as List<dynamic>? ?? [])
          .map((dish) => Dish.fromJson(dish))
          .toList(),
    );
  }
}