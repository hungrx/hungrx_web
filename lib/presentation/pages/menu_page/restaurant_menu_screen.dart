// File: lib/presentation/pages/restaurant/restaurant_menu_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_web/core/widgets/custom_navbar.dart';
import 'package:hungrx_web/data/models/menu_model.dart';
import 'package:hungrx_web/presentation/bloc/get_menu_category/get_menu_category_bloc.dart';
import 'package:hungrx_web/presentation/bloc/get_menu_category/get_menu_category_event.dart';
import 'package:hungrx_web/presentation/bloc/get_menu_category/get_menu_category_state.dart';
import 'package:hungrx_web/presentation/bloc/menu_display/menu_display_bloc.dart';
import 'package:hungrx_web/presentation/bloc/menu_display/menu_display_event.dart';
import 'package:hungrx_web/presentation/bloc/menu_display/menu_display_state.dart';
import 'package:hungrx_web/presentation/layout/app_layout.dart';
import 'package:hungrx_web/presentation/pages/menu_page/widget/category_management_widget.dart';
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
  final String restaurantId;

  const RestaurantMenuScreen({
    super.key,
    required this.restaurantName,
    required this.restaurantId,
  });

  @override
  State<RestaurantMenuScreen> createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen> {
  String selectedCategory = 'ALL';
  String selectedSubCategory = '';
  bool isDrawerOpen = true;
  List<MenuCategory> categories = [];
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      print('Initializing data for restaurant: ${widget.restaurantId}');
      _initializeData();
      _isInitialized = true;
    }
  }

  void _initializeData() {
    if (!mounted) return;
    context.read<MenuBloc>().add(FetchMenu(widget.restaurantId));
    context
        .read<GetMenuCategoryBloc>()
        .add(FetchMenuCategories(widget.restaurantId));
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentItem: NavbarItem.restaurant,
      child: MultiBlocListener(
        listeners: [
          BlocListener<GetMenuCategoryBloc, GetMenuCategoryState>(
            listener: (context, categoryState) {
              if (categoryState is GetMenuCategoryLoaded && mounted) {
                print('Categories loaded: ${categoryState.categories.length}');
                setState(() {
                  categories = [
                    MenuCategory(name: 'ALL'), // Default category
                    ...categoryState.categories.map((category) => MenuCategory(
                          name: category.name,
                          subCategories: category.subcategories
                              .map((sub) => sub.name)
                              .toList(),
                          isExpanded: false,
                        )),
                  ];
                });
              }else if (categoryState is GetMenuCategoryError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(categoryState.message)),
                );
              }
            },
          ),
          BlocListener<MenuBloc, MenuState>(
            listener: (context, menuState) {
              if (menuState is MenuError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(menuState.message)),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<MenuBloc, MenuState>(
          builder: (context, state) {
            return _buildContent(state);
          },
        ),
      ),
    );
  }

  Widget _buildContent(MenuState state) {
    return switch (state) {
      MenuLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
      MenuError(message: final message) => _buildErrorWidget(message),
      MenuLoaded(menu: final menu) => _buildLoadedContent(menu.data),
      MenuEmpty(message: final message) => _buildEmptyWidget(message),
      MenuInitial() => const SizedBox.shrink(),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error loading menu: $message',
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _initializeData(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _initializeData(),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedContent(dynamic menuData) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = MediaQuery.of(context).size.width >= 1200;
        final isTablet = MediaQuery.of(context).size.width < 1200;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDrawerOpen) _buildMenuDrawer(isTablet),
            Expanded(
              child: _buildMainContent(
                isDesktop,
                isTablet,
                menuData,
              ),
            ),
          ],
        );
      },
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
          CategoryManagementWidget(
            isTablet: isTablet,
          ),
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
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
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
                color:
                    isSubSelected ? Colors.green.shade50 : Colors.transparent,
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

  Widget _buildMainContent(bool isDesktop, bool isTablet, MenuData menuData) {
    return Padding(
      padding: EdgeInsets.all(isTablet ? 16.0 : 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isDesktop, isTablet, widget.restaurantName),
          SizedBox(height: isTablet ? 24 : 32),
          Expanded(
            child: _buildDishesGrid(isDesktop, isTablet, menuData),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDesktop, bool isTablet, String restaurantName) {
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
                restaurantName.toUpperCase(),
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
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          context.pushNamed(
                            'menuSearch',
                            pathParameters: {
                              'restaurantId': widget.restaurantId
                            },
                            queryParameters: {'q': value},
                          );
                        }
                      },
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

  Widget _buildDishesGrid(bool isDesktop, bool isTablet, MenuData menuData) {
    // Checking if menu items are available
    if (menuData.menu.isEmpty) {
      return const Center(child: Text("No dishes available"));
    }

    final dishes = menuData.menu.expand((menu) => menu.dishes).toList();

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
          itemCount: dishes.length,
          itemBuilder: (context, index) {
            final dish = dishes[index];
            return DishCard(
              name: dish.name,
              price:
                  '\$${dish.nutritionFacts.calories}', // Example placeholder for price
              calories: dish.nutritionFacts.calories.toString(),
              protein: dish.nutritionFacts.protein.value.toString(),
              carbs: "23G", // Placeholder for carbs, adjust if available
              fat: dish.nutritionFacts.totalFat.value.toString(),
              image: dish.image,
              onTap: () => _showDishDetails(),
              onEdit: () async {
                final result = await showDialog<Map<String, dynamic>>(
                  context: context,
                  builder: (context) {
                    return DishEditDialog(
                      initialData: {
                        'name': dish.name,
                        'price': '\$12.95', // Example placeholder for price
                        'calories': dish.nutritionFacts.calories.toString(),
                        'protein': dish.nutritionFacts.protein.value.toString(),
                        'carbs': "23G", // Placeholder for carbs
                        'fat': dish.nutritionFacts.totalFat.value.toString(),
                      },
                    );
                  },
                );

                if (result != null) {
                  print(result);
                }
              },
            );
          },
        );
      },
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
