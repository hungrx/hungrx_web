import 'package:flutter/material.dart';
import 'package:hungrx_web/core/widgets/custom_header.dart';
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 1200;
          final isTablet = constraints.maxWidth < 1200;

          return Padding(
            padding: EdgeInsets.all(isTablet ? 16.0 : 24.0),
            child: _buildMainContent(context, isDesktop: isDesktop, isTablet: isTablet),
          );
        },
      ),
    );
  }

  Widget _buildMainContent(
    BuildContext context, {
    required bool isDesktop,
    required bool isTablet,
  }) {
    return Column(
      children: [
        CustomHeader(
                  title: 'COMMON FOODS',
                  searchHint: 'Search foods...',
                  buttonLabel: 'ADD FOOD',
                  isTablet: isTablet,
                  onAddPressed: () {
                    // Handle add button press
                  },
                  onSearchChanged: (value) {
                    // Handle search
                  },
                ),
        SizedBox(height: isTablet ? 24 : 32),
        Expanded(
          child: _buildFoodGrid(context, isDesktop, isTablet),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isTablet) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'COMMON FOODS',
          style: TextStyle(
            fontSize: isTablet ? 24 : 32,
            fontWeight: FontWeight.bold,
          ),
        ),
         SizedBox(width: MediaQuery.of(context).size.width * 0.22),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: isTablet ? 200 : 300,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search foods...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 16 : 20,
                    vertical: isTablet ? 12 : 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () => _showAddFoodDialog(),
              icon: const Icon(Icons.add),
              label: Text(
                isTablet ? 'ADD' : 'ADD DISH',
                style: TextStyle(fontSize: isTablet ? 13 : 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 16 : 24,
                  vertical: isTablet ? 12 : 16,
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

Widget _buildFoodGrid(BuildContext context, bool isDesktop, bool isTablet) {
  return LayoutBuilder(
    builder: (context, constraints) {
      // Calculate number of columns and aspect ratio based on screen width
      int crossAxisCount;
      double childAspectRatio;
      double spacing;
      
      if (isDesktop) {
        // Desktop layout (1200px and above)
        if (constraints.maxWidth >= 1800) {
          crossAxisCount = 5; // Extra large screens
          childAspectRatio = 1.3;
          spacing = 32;
        } else {
          crossAxisCount = 4; // Regular desktop
          childAspectRatio = 1.2;
          spacing = 28;
        }
      } else {
        // Tablet layout (below 1200px)
        if (constraints.maxWidth >= 1000) {
          crossAxisCount = 4; // Larger tablets
          childAspectRatio = 1.1;
          spacing = 24;
        } else if (constraints.maxWidth >= 800) {
          crossAxisCount = 3; // Regular tablets
          childAspectRatio = 1.0;
          spacing = 20;
        } else {
          crossAxisCount = 2; // Small tablets
          childAspectRatio = 1.2;
          spacing = 16;
        }
      }

      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? spacing / 2 : spacing,
        ),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
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
            ];
            
            return Padding(
              padding: EdgeInsets.all(spacing / 4),
              child: FoodCard(
                food: foods[index % foods.length],
                onShowDetails: (food) => _showFoodDetails(context, food, isTablet),
              ),
            );
          },
        ),
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

  void _showFoodDetails(BuildContext context, Map<String, String> food, bool isTablet) {
    final screenSize = MediaQuery.of(context).size;
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: isTablet ? screenSize.width * 0.6 : screenSize.width * 0.4,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    food['name']!,
                    style: TextStyle(
                      fontSize: isTablet ? 20 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: Image.asset(
                  food['image']!,
                  width: isTablet ? 150 : 200,
                  height: isTablet ? 150 : 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: isTablet ? 150 : 200,
                      height: isTablet ? 150 : 200,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(Icons.fastfood, size: 50),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildNutritionRow('CALORIES', food['calories']!),
                    _buildNutritionRow('PROTEIN', food['protein']!),
                    _buildNutritionRow('CARBS', food['carbs']!),
                    _buildNutritionRow('FAT', food['fat']!),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddFoodDialog() {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width < 1200;
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: isTablet ? screenSize.width * 0.8 : screenSize.width * 0.4,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add New Food',
                    style: TextStyle(
                      fontSize: isTablet ? 20 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Food Name',
                  hintText: 'Enter food name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Calories',
                        hintText: 'Enter calories',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Protein',
                        hintText: 'Enter protein',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Carbs',
                        hintText: 'Enter carbs',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Fat',
                        hintText: 'Enter fat',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Handle adding new food
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Add Food'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}