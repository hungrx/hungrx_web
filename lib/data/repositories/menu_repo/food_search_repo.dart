import 'dart:async';
import 'dart:math';

import 'package:hungrx_web/data/models/menu_models/search_food_model.dart';

class FoodRepository {
  // Singleton pattern
  static final FoodRepository _instance = FoodRepository._internal();
  factory FoodRepository() => _instance;
  FoodRepository._internal();

  // Dummy data
  final List<Food> _foods = [
    Food(
      id: '1',
      name: 'BONELESS WINGS AND, BBQ',
      imageUrl: 'https://healux.in/wp-content/uploads/2020/11/ChickenBiryani.jpg',
      lastUpdated: '12-jan-2024',
      category: 'APPETIZER',
      subCategory: 'WINGS',
      nutritionInfo: NutritionInfo(
        calories: 360,
        protein: 32,
        carbs: 23,
        fat: 50,
      ),
    ),
    Food(
      id: '2',
      name: 'DUM BIRIYANI',
      imageUrl: 'https://healux.in/wp-content/uploads/2020/11/ChickenBiryani.jpg',
      lastUpdated: '12-jan-2024',
      category: 'MAIN COURSE',
      subCategory: 'RICE',
      nutritionInfo: NutritionInfo(
        calories: 450,
        protein: 25,
        carbs: 65,
        fat: 18,
      ),
    ),
    Food(
      id: '3',
      name: 'CANDY JUST JULLY',
      imageUrl: 'https://healux.in/wp-content/uploads/2020/11/ChickenBiryani.jpg',
      lastUpdated: '12-jan-2024',
      category: 'DESSERT',
      nutritionInfo: NutritionInfo(
        calories: 200,
        protein: 0,
        carbs: 48,
        fat: 0,
      ),
    ),
    Food(
      id: '4',
      name: 'SMOKED BRISKET',
      imageUrl: 'https://healux.in/wp-content/uploads/2020/11/ChickenBiryani.jpg',
      lastUpdated: '12-jan-2024',
      category: 'MAIN COURSE',
      subCategory: 'BEEF',
      nutritionInfo: NutritionInfo(
        calories: 320,
        protein: 28,
        carbs: 0,
        fat: 22,
      ),
    ),
    Food(
      id: '5',
      name: 'CAESAR SALAD',
      imageUrl: 'https://healux.in/wp-content/uploads/2020/11/ChickenBiryani.jpg',
      lastUpdated: '12-jan-2024',
      category: 'SALAD',
      nutritionInfo: NutritionInfo(
        calories: 180,
        protein: 8,
        carbs: 12,
        fat: 12,
      ),
    ),
  ];

  // Simulates network delay
  final _random = Random();
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(Duration(milliseconds: 500 + _random.nextInt(1000)));
  }

  // Search foods
  Future<List<Food>> searchFoods(String query) async {
    await _simulateNetworkDelay();

    if (_random.nextDouble() < 0.1) {
      throw Exception('Failed to fetch foods. Please try again.');
    }

    if (query.isEmpty) {
      return [];
    }

    return _foods.where((food) {
      return food.name.toLowerCase().contains(query.toLowerCase()) ||
          (food.category?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
          (food.subCategory?.toLowerCase().contains(query.toLowerCase()) ?? false);
    }).toList();
  }

  // Get food by ID
  Future<Food?> getFoodById(String id) async {
    await _simulateNetworkDelay();

    try {
      return _foods.firstWhere((food) => food.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add food to category
  Future<bool> addFoodToCategory(String foodId, String category, {String? subCategory}) async {
    await _simulateNetworkDelay();

    try {
      final foodIndex = _foods.indexWhere((food) => food.id == foodId);
      if (foodIndex == -1) {
        return false;
      }

      // Create a new food object with updated category
      _foods[foodIndex] = Food(
        id: _foods[foodIndex].id,
        name: _foods[foodIndex].name,
        imageUrl: _foods[foodIndex].imageUrl,
        lastUpdated: DateTime.now().toString(),
        category: category,
        subCategory: subCategory,
        nutritionInfo: _foods[foodIndex].nutritionInfo,
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  // Get all categories
  Future<List<String>> getAllCategories() async {
    await _simulateNetworkDelay();

    return _foods
        .where((food) => food.category != null)
        .map((food) => food.category!)
        .toSet()
        .toList();
  }

  // Get subcategories for a category
  Future<List<String>> getSubCategories(String category) async {
    await _simulateNetworkDelay();

    return _foods
        .where((food) => food.category == category && food.subCategory != null)
        .map((food) => food.subCategory!)
        .toSet()
        .toList();
  }
}