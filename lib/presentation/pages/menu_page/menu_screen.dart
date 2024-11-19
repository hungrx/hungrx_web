import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_web/core/widgets/custom_navbar.dart';
import 'package:hungrx_web/data/models/menu_models/get_category_subcategory_model.dart';
import 'package:hungrx_web/data/models/menu_models/menu_model.dart';
import 'package:hungrx_web/data/repositories/menu_repo/food_search_repo.dart';
import 'package:hungrx_web/presentation/bloc/get_category_subcategory/get_category_subcategory_bloc.dart';
import 'package:hungrx_web/presentation/bloc/get_category_subcategory/get_category_subcategory_event.dart';
import 'package:hungrx_web/presentation/bloc/get_category_subcategory/get_category_subcategory_state.dart';
import 'package:hungrx_web/presentation/bloc/get_dishes_by%20category/get_dishes_by_category_bloc.dart';
import 'package:hungrx_web/presentation/bloc/get_dishes_by%20category/get_dishes_by_category_event.dart';
import 'package:hungrx_web/presentation/bloc/get_dishes_by%20category/get_dishes_by_category_state.dart';
import 'package:hungrx_web/presentation/bloc/menu_display/menu_display_bloc.dart';
import 'package:hungrx_web/presentation/bloc/menu_display/menu_display_event.dart';
import 'package:hungrx_web/presentation/bloc/menu_display/menu_display_state.dart';
import 'package:hungrx_web/presentation/bloc/search_food_dialog/search_food_dialog_bloc.dart';
import 'package:hungrx_web/presentation/layout/app_layout.dart';
import 'package:hungrx_web/presentation/pages/menu_page/widget/category_management_widget.dart';
import 'package:hungrx_web/presentation/pages/menu_page/widget/dish_card_widget.dart';
import 'package:hungrx_web/presentation/pages/menu_page/widget/dish_edit_dialog.dart';
import 'package:hungrx_web/presentation/pages/menu_page/widget/food_search_dialog.dart';


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
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _initializeData();
      _isInitialized = true;
    }
  }

  void _initializeData() {
    if (!mounted) return;
        context.read<GetCategorySubcategoryBloc>().add(
          FetchCategoriesAndSubcategoriesEvent(
            restaurantId: widget.restaurantId,
          ),
        );
    context.read<MenuBloc>().add(FetchMenu(widget.restaurantId));
  }
  
  void _onCategorySelected(String categoryId) {
  context.read<GetDishesByCategoryBloc>().add(
    FetchDishesByCategoryEvent(
      restaurantId: widget.restaurantId,
      categoryId: categoryId,
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      
      currentItem: NavbarItem.restaurant,
      child: MultiBlocListener(
        listeners: [

            BlocListener<GetDishesByCategoryBloc, GetDishesByCategoryState>(
            listener: (context, state) {
              if (state is GetDishesByCategoryError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
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
      
      return Stack(  // Wrap Row with Stack to overlay FAB
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isDrawerOpen) _buildAlwaysVisibleDrawer(isTablet),
              Expanded(
                child: _buildMainContent(
                  isDesktop,
                  isTablet,
                  menuData,
                ),
              ),
            ],
          ),
          Positioned(  // Add FAB using Positioned
            right: 20,
            bottom: 20,
            child: FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => BlocProvider(
                    create: (context) => FoodSearchBloc(
                      foodRepository: FoodRepository(),
                    ),
                    child: const FoodSearchDialog(),
                  ),
                );
              },
              backgroundColor: Colors.green,
              label: const Row(
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'ADD DISH',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}
  Widget _buildAlwaysVisibleDrawer(bool isTablet) {
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
        // ALL button
        InkWell(
          onTap: () {
            setState(() {
              selectedCategory = 'ALL';
              selectedSubCategory = '';
            });
          },
          child: Container(
            color: selectedCategory == 'ALL' 
                ? Colors.green.shade100 
                : Colors.transparent,
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 16 : 24,
              vertical: isTablet ? 12 : 16,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.restaurant_menu,
                  size: isTablet ? 18 : 20,
                  color: selectedCategory == 'ALL' 
                      ? Colors.green 
                      : Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'ALL MENU ITEMS',
                    style: TextStyle(
                      color: selectedCategory == 'ALL' 
                          ? Colors.green 
                          : Colors.grey[700],
                      fontWeight: selectedCategory == 'ALL' 
                          ? FontWeight.bold 
                          : FontWeight.normal,
                      fontSize: isTablet ? 13 : 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(color: Colors.grey.shade200),
        // Categories section
        Expanded(
          child: BlocBuilder<GetCategorySubcategoryBloc, GetCategorySubcategoryState>(
            builder: (context, state) {
              if (state is GetCategorySubcategoryLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is GetCategorySubcategoryError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[400]),
                      const SizedBox(height: 8),
                      Text(
                        'Failed to load categories',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: isTablet ? 12 : 14,
                        ),
                      ),
                      TextButton(
                        onPressed: _initializeData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is GetCategorySubcategoryLoaded) {
                if (state.categories.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.category_outlined,
                          color: Colors.grey[400],
                          size: 24,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No categories available',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: isTablet ? 12 : 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Add categories below',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: isTablet ? 11 : 13,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    final category = state.categories[index];
                    return _buildExpandableCategory(category, isTablet);
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
        Divider(color: Colors.grey.shade200),
        // Always show category management widget
        CategoryManagementWidget(
          restaurantId: widget.restaurantId,
          isTablet: isTablet,
        ),
      ],
    ),
  );
}


  Widget _buildExpandableCategory(MenuCategory category, bool isTablet) {
    final bool hasSubCategories = category.subcategories.isNotEmpty;
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
          ...category.subcategories.map((subCategory) {
            final bool isSubSelected = subCategory.name == selectedSubCategory;
            return InkWell(
              onTap: () {
                setState(() {
                  selectedSubCategory = subCategory.name;
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
                     subCategory.name,
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
    selectedCategory == 'ALL'
                ? 'All Menu Items'
                : selectedSubCategory.isEmpty
                    ? selectedCategory
                    : '$selectedCategory > $selectedSubCategory';
    return Padding(
      padding: EdgeInsets.all(isTablet ? 16.0 : 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          _buildHeader(isDesktop, isTablet, selectedCategory),
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
                  icon: const Icon(Icons.create),
                  label: Text(
                    isTablet ? 'CREATE' : 'CREATE DISH',
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
              price:'\$${dish.nutritionFacts.calories.toString()}', 
              calories: dish.nutritionFacts.calories.toString(),
              protein: dish.nutritionFacts.protein.value.toString(),
              carbs: dish.nutritionFacts.totalCarbohydrates.toString(), 
              fat: dish.nutritionFacts.totalFat.value.toString(),
              image: dish.image,
              onTap: () {
                // _showDishDetails();
              },
              onEdit: () async {
                await showDialog<Map<String, dynamic>>(
                  context: context,
                  builder: (context) {
                    return DishEditDialog(
                      dishId: dish.id,
                      menuId:menuData.menu.first.id,
                      restaurantId: widget.restaurantId,
                      initialData: {
                        'name': dish.name,
                        'price': '12.95', // Example placeholder for price
                        'calories': dish.nutritionFacts.calories.toString(),
                        'protein': dish.nutritionFacts.protein.value.toString(),
                        'carbs': "23G", // Placeholder for carbs
                        'fat': dish.nutritionFacts.totalFat.value.toString(),
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
