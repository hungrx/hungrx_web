// File: lib/presentation/pages/restaurant/restaurant_menu_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_web/core/widgets/custom_navbar.dart';
import 'package:hungrx_web/presentation/layout/app_layout.dart';
import 'package:hungrx_web/presentation/pages/menu_page/widget/dish_card_widget.dart';
import 'package:hungrx_web/presentation/pages/menu_page/widget/dish_edit_dialog.dart';

class MenuCategory {
  final String name;
  final List<String> subCategories;
  bool isExpanded;

  MenuCategory({
    required this.name,
    this.subCategories = const [],
    this.isExpanded = false,
  });
}

class RestaurantMenuScreen extends StatefulWidget {
  final String restaurantName;

  const RestaurantMenuScreen({
    super.key,
    required this.restaurantName,
  });

  @override
  State<RestaurantMenuScreen> createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen> {
  String selectedCategory = 'ALL';
  String selectedSubCategory = '';
   bool isDrawerOpen = true;
  final List<MenuCategory> categories = [
    MenuCategory(name: 'ALL'),
    MenuCategory(
      name: 'BURRITO',
      subCategories: ['CHICKEN', 'BEEF', 'VEGGIE'],
    ),
    MenuCategory(
      name: 'BUTTITO BOWL',
      subCategories: ['CLASSIC', 'SPECIAL'],
    ),
    MenuCategory(
      name: 'LIFESTYLE BOWL',
      subCategories: ['KETO', 'PALEO', 'WHOLE30'],
    ),
    MenuCategory(name: 'QUESADILLA'),
    MenuCategory(
      name: 'SALAD',
      subCategories: ['REGULAR', 'PROTEIN'],
    ),
    MenuCategory(name: 'TORTILLA'),
    MenuCategory(name: 'INCLUDED TOPPINGS'),
    MenuCategory(name: 'ADD-ONS'),
  ];

  @override
   Widget build(BuildContext context) {
    return AppLayout(
      currentItem: NavbarItem.restaurant,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 1200;
          final isTablet = constraints.maxWidth < 1200;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isDrawerOpen)
                _buildMenuDrawer(isTablet),
              Expanded(
                child: _buildMainContent(isDesktop, isTablet),
              ),
            ],
          );
        },
      ),
    );
  }

Widget _buildMenuDrawer(bool isTablet) {
    return Container(
      width: isTablet ? 200 : 250,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        children: [
          if (isTablet)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.menu_open),
                onPressed: () {
                  setState(() {
                    isDrawerOpen = false;
                  });
                },
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return _buildExpandableCategory(category, isTablet);
              },
            ),
          ),
          _buildNewCategoryButton(isTablet),
        ],
      ),
    );
  }

 Widget _buildExpandableCategory(MenuCategory category, bool isTablet) {
    final bool hasSubCategories = category.subCategories.isNotEmpty;
    final bool isSelected = category.name == selectedCategory;

    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              if (hasSubCategories) {
                category.isExpanded = !category.isExpanded;
              }
              selectedCategory = category.name;
              selectedSubCategory = '';
            });
          },
          child: Container(
            color: isSelected ? Colors.green.shade100 : Colors.transparent,
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 16 : 24,
              vertical: isTablet ? 12 : 16,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    category.name,
                    style: TextStyle(
                      color: isSelected ? Colors.green : Colors.grey[700],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: isTablet ? 13 : 14,
                    ),
                  ),
                ),
                if (hasSubCategories)
                  Icon(
                    category.isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey[600],
                    size: isTablet ? 20 : 24,
                  ),
              ],
            ),
          ),
        ),
        if (hasSubCategories && category.isExpanded)
          ...category.subCategories.map((subCategory) {
            final bool isSubSelected = subCategory == selectedSubCategory;
            return InkWell(
              onTap: () {
                setState(() {
                  selectedSubCategory = subCategory;
                });
              },
              child: Container(
                color: isSubSelected ? Colors.green.shade50 : Colors.transparent,
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32 : 48,
                  vertical: isTablet ? 8 : 12,
                ),
                child: Row(
                  children: [
                    Text(
                      subCategory,
                      style: TextStyle(
                        color: isSubSelected ? Colors.green : Colors.grey[600],
                        fontSize: isTablet ? 12 : 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildNewCategoryButton(bool isTablet) {
    return Padding(
      padding: EdgeInsets.all(isTablet ? 12.0 : 16.0),
      child: ElevatedButton.icon(
        onPressed: _showAddCategoryDialog,
        icon: Icon(Icons.add, size: isTablet ? 18 : 24),
        label: Text(
          isTablet ? 'NEW' : 'NEW CATEGORY',
          style: TextStyle(fontSize: isTablet ? 12 : 14),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            vertical: isTablet ? 12 : 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

Widget _buildMainContent(bool isDesktop, bool isTablet) {
    return Padding(
      padding: EdgeInsets.all(isTablet ? 16.0 : 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isDesktop, isTablet),
          SizedBox(height: isTablet ? 24 : 32),
          Expanded(
            child: _buildDishesGrid(isDesktop, isTablet),
          ),
        ],
      ),
    );
  }

 Widget _buildHeader(bool isDesktop, bool isTablet) {
    return SizedBox(
      width: double.infinity,
      child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isDrawerOpen)
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    setState(() {
                      isDrawerOpen = true;
                    });
                  },
                ),
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Back to Restaurants',
              ),
              const SizedBox(width: 16),
              Text(
                widget.restaurantName.toUpperCase(),
                style: TextStyle(
                  fontSize: isTablet ? 24 : 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
      
      
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: isTablet ? 400 : 500,
              ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: SizedBox(
                    width: isTablet ? 200 : 300,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search menu items...',
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
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle adding new dish
                  },
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
          ),
        ],
      ),
    );
  }

  Widget _buildDishesGrid(bool isDesktop, bool isTablet) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        double childAspectRatio = 1.5;
        double spacing;

        if (isDesktop) {
          if (constraints.maxWidth >= 1800) {
            crossAxisCount = 4;
            spacing = 32;
          } else if (constraints.maxWidth >= 1400) {
            crossAxisCount = 3;
            spacing = 28;
          } else {
            crossAxisCount = 2;
            spacing = 24;
          }
        } else {
          if (constraints.maxWidth >= 1000) {
            crossAxisCount = 2;
            spacing = 20;
          } else {
            crossAxisCount = 1;
            spacing = 16;
          }
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemCount: 9,
          itemBuilder: (context, index) => DishCard(
            onTap: _showDishDetails,
            onEdit: () async {
              final result = await showDialog<Map<String, dynamic>>(
                context: context,
                builder: (context) => const DishEditDialog(
                  initialData: {
                    'name': 'SMOKED BRISKET',
                    'price': 12.95,
                    'calories': '360',
                    'protein': '32',
                    'carbs': '23',
                    'fat': '50',
                  },
                ),
              );
              
              if (result != null) {
                // Handle the updated dish data
                print(result);
              }
            },
          ),
        );
      },
    );
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add New Category'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Category Name',
              hintText: 'Enter category name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    categories.add(MenuCategory(name: controller.text.toUpperCase()));
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Add'),
            ),
          ],
        );
      }
      );
    
  }

  void _showDishDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('SMOKED BRISKET'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/smoked_brisket.jpg',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            const Text(
              '\$12.95',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // _buildNutritionInfo('CALORIE', '360G'),
            // _buildNutritionInfo('PROTEIN', '32G'),
            // _buildNutritionInfo('CARBS', '23G'),
            // _buildNutritionInfo('FAT', '50G'),
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
}