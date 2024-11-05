// File: lib/presentation/pages/common_food/common_food_screen.dart
import 'package:flutter/material.dart';
import 'package:hungrx_web/core/widgets/custom_navbar.dart';
import 'package:hungrx_web/presentation/layout/app_layout.dart';
import 'package:hungrx_web/presentation/pages/common_food_page/widgets/food_card_widget.dart';

class CommonFoodScreen extends StatefulWidget {
  const CommonFoodScreen({super.key});

  @override
  State<CommonFoodScreen> createState() => _CommonFoodScreenState();
}

class _CommonFoodScreenState extends State<CommonFoodScreen> {
  @override
   Widget build(BuildContext context) {
    return AppLayout(
      currentItem: NavbarItem.commonFood,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _buildMainContent(context),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          _buildHeader(context),
          const SizedBox(height: 32),
          Expanded(
            child: _buildFoodGrid(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'COMMON FOODS',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            SizedBox(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search foods...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () => _showAddFoodDialog(),
              icon: const Icon(Icons.add),
              label: const Text('ADD DISH'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFoodGrid(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.2,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        // Example food items
        final foods = [
          {
            'name': '0 GREEK YOGURT',
            'image': 'assets/images/yogurt.jpg',
            'calories': '360G',
            'protein': '32G',
            'carbs': '23G',
            'fat': '50G',
          },
          {
            'name': 'OREO',
            'image': 'assets/images/oreo.jpg',
            'calories': '360G',
            'protein': '32G',
            'carbs': '23G',
            'fat': '50G',
          },
          // Add more food items here
        ];
        
        return FoodCard(
          food: foods[index % foods.length],
          onShowDetails: (food) => _showFoodDetails(context, food),
        );
      },
    );
  }

  Widget _buildNutritionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showFoodDetails(BuildContext context, Map<String, String> food) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(food['name']!),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              food['image']!,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 200,
                  height: 200,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Icon(Icons.fastfood, size: 50),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildNutritionRow('CALORIE', food['calories']!),
            _buildNutritionRow('PROTEIN', food['protein']!),
            _buildNutritionRow('CARBS', food['carbs']!),
            _buildNutritionRow('FAT', food['fat']!),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAddFoodDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Food'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Food Name',
                hintText: 'Enter food name',
              ),
            ),
            SizedBox(height: 16),
            // Add more fields for nutrition information
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle adding new food
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}