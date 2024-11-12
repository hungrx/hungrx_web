// menu_model.dart
class MenuResponse {
  final bool status;
  final MenuData data;

  MenuResponse({required this.status, required this.data});

  factory MenuResponse.fromJson(Map<String, dynamic> json) {
    try {
      return MenuResponse(
        status: json['status'] ?? false,
        data: MenuData.fromJson(json['data'] ?? {}),
      );
    } catch (e) {
      throw FormatException('Error parsing MenuResponse: $e');
    }
  }
}

class MenuData {
  final String name;
  final List<Menu> menu;

  MenuData({required this.name, required this.menu});

  factory MenuData.fromJson(Map<String, dynamic> json) {
    try {
      return MenuData(
        name: json['name'] ?? '',
        menu: (json['menu'] as List? ?? [])
            .map((e) => Menu.fromJson(e))
            .toList(),
      );
    } catch (e) {
      throw FormatException('Error parsing MenuData: $e');
    }
  }
}

class Menu {
  final String id;
  final String name;
  final List<Dish> dishes;

  Menu({required this.id, required this.name, required this.dishes});

  factory Menu.fromJson(Map<String, dynamic> json) {
    try {
      return Menu(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        dishes: (json['dishes'] as List? ?? [])
            .map((e) => Dish.fromJson(e))
            .toList(),
      );
    } catch (e) {
      throw FormatException('Error parsing Menu: $e');
    }
  }
}

class Dish {
  final String id;
  final String name;
  final String image;
  final ServingInfo servingInfo;
  final NutritionFacts nutritionFacts;

  Dish({
    required this.id,
    required this.name,
    required this.image,
    required this.servingInfo,
    required this.nutritionFacts,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    try {
      return Dish(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        image: json['image'] ?? '',
        servingInfo: ServingInfo.fromJson(json['servingInfo'] ?? {}),
        nutritionFacts: NutritionFacts.fromJson(json['nutritionFacts'] ?? {}),
      );
    } catch (e) {
      throw FormatException('Error parsing Dish: $e');
    }
  }
}

class ServingInfo {
  final double size;
  final String unit;
  final String equivalentTo;

  ServingInfo({
    required this.size,
    required this.unit,
    required this.equivalentTo,
  });

  factory ServingInfo.fromJson(Map<String, dynamic> json) {
    try {
      return ServingInfo(
        size: _parseDouble(json['size']),
        unit: json['unit'] ?? '',
        equivalentTo: json['equivalentTo'] ?? '',
      );
    } catch (e) {
      throw FormatException('Error parsing ServingInfo: $e');
    }
  }
}

class NutritionFacts {
  final int calories;
  final NutritionValue totalFat;
  final NutritionValue saturatedFat;
  final NutritionValue transFat;
  final NutritionValue cholesterol;
  final NutritionValue sodium;
  final NutritionValue totalCarbohydrates;
  final NutritionValue dietaryFiber;
  final NutritionValue sugars;
  final NutritionValue protein;

  NutritionFacts({
    required this.calories,
    required this.totalFat,
    required this.saturatedFat,
    required this.transFat,
    required this.cholesterol,
    required this.sodium,
    required this.totalCarbohydrates,
    required this.dietaryFiber,
    required this.sugars,
    required this.protein,
  });

  factory NutritionFacts.fromJson(Map<String, dynamic> json) {
    try {
      return NutritionFacts(
        calories: _parseInt(json['calories']),
        totalFat: NutritionValue.fromJson(json['totalFat'] ?? {}),
        saturatedFat: NutritionValue.fromJson(json['saturatedFat'] ?? {}),
        transFat: NutritionValue.fromJson(json['transFat'] ?? {}),
        cholesterol: NutritionValue.fromJson(json['cholesterol'] ?? {}),
        sodium: NutritionValue.fromJson(json['sodium'] ?? {}),
        totalCarbohydrates: NutritionValue.fromJson(json['totalCarbohydrates'] ?? {}),
        dietaryFiber: NutritionValue.fromJson(json['dietaryFiber'] ?? {}),
        sugars: NutritionValue.fromJson(json['sugars'] ?? {}),
        protein: NutritionValue.fromJson(json['protein'] ?? {}),
      );
    } catch (e) {
      throw FormatException('Error parsing NutritionFacts: $e');
    }
  }
}

class NutritionValue {
  final double value;

  NutritionValue({required this.value});

  factory NutritionValue.fromJson(Map<String, dynamic> json) {
    try {
      return NutritionValue(value: _parseDouble(json['value']));
    } catch (e) {
      throw FormatException('Error parsing NutritionValue: $e');
    }
  }
}

// Helper functions for parsing numeric values
double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is int) return value.toDouble();
  if (value is double) return value;
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.round();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}