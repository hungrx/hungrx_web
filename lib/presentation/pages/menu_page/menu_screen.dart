import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_web/core/widgets/custom_navbar.dart';
import 'package:hungrx_web/data/datasource/api/menu_api/add_food_category_api.dart';
import 'package:hungrx_web/data/datasource/api/menu_api/dish_api_service.dart';
import 'package:hungrx_web/data/datasource/api/menu_api/quick_search_api.dart';
import 'package:hungrx_web/data/models/menu_models/get_category_subcategory_model.dart';
import 'package:hungrx_web/data/models/menu_models/menu_model.dart';
import 'package:hungrx_web/data/repositories/menu_repo/add_food_category_repository.dart';
import 'package:hungrx_web/data/repositories/menu_repo/dish_repository.dart';
import 'package:hungrx_web/data/repositories/menu_repo/quick_search_repository.dart';
import 'package:hungrx_web/domain/usecase/manu_usecase/create_new_dish_usecase.dart';
import 'package:hungrx_web/presentation/bloc/add_food_to_category/add_food_to_category_bloc.dart';
import 'package:hungrx_web/presentation/bloc/create_new_dish/create_new_dish_bloc.dart';
import 'package:hungrx_web/presentation/bloc/get_category_subcategory/get_category_subcategory_bloc.dart';
import 'package:hungrx_web/presentation/bloc/get_category_subcategory/get_category_subcategory_event.dart';
import 'package:hungrx_web/presentation/bloc/get_category_subcategory/get_category_subcategory_state.dart';
import 'package:hungrx_web/presentation/bloc/get_dishes_by%20category/get_dishes_by_category_bloc.dart';
import 'package:hungrx_web/presentation/bloc/get_dishes_by%20category/get_dishes_by_category_event.dart';
import 'package:hungrx_web/presentation/bloc/get_dishes_by%20category/get_dishes_by_category_state.dart';
import 'package:hungrx_web/presentation/bloc/menu_display/menu_display_bloc.dart';
import 'package:hungrx_web/presentation/bloc/menu_display/menu_display_event.dart';
import 'package:hungrx_web/presentation/bloc/menu_display/menu_display_state.dart';
import 'package:hungrx_web/presentation/bloc/menu_quick_search/menu_quick_search_dialog_bloc.dart';
import 'package:hungrx_web/presentation/layout/app_layout.dart';
import 'package:hungrx_web/presentation/pages/menu_page/widget/category_management_widget.dart';
import 'package:hungrx_web/presentation/pages/menu_page/widget/create_dish_dialog.dart';
import 'package:hungrx_web/presentation/pages/menu_page/widget/dish_card_widget.dart';
import 'package:hungrx_web/presentation/pages/menu_page/widget/dish_edit_dialog.dart';
import 'package:hungrx_web/presentation/pages/menu_page/widget/edit_category_dialog.dart';
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
  String selectedCategoryId = '';
  bool isDrawerOpen = true;
  bool _isInitialized = false;
  String menuId = '';
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
    _loadAllMenuItems();
    // context.read<MenuBloc>().add(FetchMenu(widget.restaurantId));
  }

  void _loadAllMenuItems() {
    context.read<MenuBloc>().add(FetchMenu(widget.restaurantId));
  }

  void _loadCategoryDishes(String categoryId) {
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
        child: _buildMainLayout(),
      ),
    );
  }

  Widget _buildMainLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = MediaQuery.of(context).size.width >= 1200;
        final isTablet = MediaQuery.of(context).size.width < 1200;

        return Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isDrawerOpen) _buildAlwaysVisibleDrawer(isTablet),
                Expanded(
                  child: _buildContentArea(isDesktop, isTablet),
                ),
              ],
            ),
            _buildFab(),
          ],
        );
      },
    );
  }

  Widget _buildContentArea(bool isDesktop, bool isTablet) {
    return Padding(
      padding: EdgeInsets.all(isTablet ? 16.0 : 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isDesktop, isTablet, widget.restaurantName),
          SizedBox(height: isTablet ? 24 : 32),
          Expanded(
            child: selectedCategory == 'ALL'
                ? _buildAllDishesContent(isDesktop, isTablet)
                : _buildCategoryDishesContent(isDesktop, isTablet),
          ),
        ],
      ),
    );
  }

  Widget _buildAllDishesContent(bool isDesktop, bool isTablet) {
    return BlocBuilder<MenuBloc, MenuState>(
      builder: (context, state) {
        return switch (state) {
          MenuLoading() => const Center(child: CircularProgressIndicator()),
          MenuError(message: final message) => _buildErrorWidget(message),
          MenuLoaded(menu: final menu) =>
            _buildDishesGrid(isDesktop, isTablet, menu.data),
          MenuEmpty(message: final message) => _buildEmptyWidget(message),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }

  Widget _buildCategoryDishesContent(bool isDesktop, bool isTablet) {
    return BlocBuilder<GetDishesByCategoryBloc, GetDishesByCategoryState>(
      builder: (context, state) {
        return switch (state) {
          GetDishesByCategoryLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          GetDishesByCategoryError(message: final message) =>
            _buildErrorWidget(message),
          GetDishesByCategoryLoaded(data: final data) => _buildDishesGrid(
              isDesktop,
              isTablet,
              MenuData(
                name: data.menuInfo.name,
                menu: [
                  Menu(
                    id: data.menuInfo.id,
                    name: data.menuInfo.name,
                    dishes: data.dishes,
                  ),
                ],
              ),
            ),
          GetDishesByCategoryInitial() => const Center(
              child: Text('Select a category to view dishes'),
            ),
          _ => const Center(
              child: Text('Select a category to view dishes'),
            ),
        };
      },
    );
  }

//* the floating button for add dishes to category

  Widget _buildFab() {
    return Positioned(
      right: 20,
      bottom: 20,
      child: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: true,
            useRootNavigator: true,
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => QuickSearchBloc(
                    repository: QuickSearchRepository(
                      api: QuickSearchApi(),
                    ),
                  ),
                ),
                BlocProvider(
                  create: (context) => AddFoodCategoryBloc(
                    repository: AddFoodCategoryRepository(
                      api: AddFoodCategoryApi(),
                    ),
                  ),
                ),
              ],
              child: FoodSearchDialog(
                restaurantId: widget.restaurantId,
                menuId: menuId,
                categoryId: selectedCategoryId,
                subcategoryId:
                    selectedSubCategory.isNotEmpty ? selectedSubCategory : null,
                onFoodSelected: (dish) {
                  // print(dish);
                },
              ),
            ),
          );
        },
        backgroundColor: Colors.green,
        label: const Row(
          children: [
            Icon(Icons.add, color: Colors.white),
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
    );
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

  Widget _buildAlwaysVisibleDrawer(bool isTablet) {
    return Container(
      width: isTablet ? 200 : 250,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          if (isTablet) _buildDrawerToggle(),
          _buildAllMenuButton(isTablet),
          Divider(color: Colors.grey.shade200),
          Expanded(
            child: _buildCategoriesList(isTablet),
          ),
          Divider(color: Colors.grey.shade200),
          CategoryManagementWidget(
            restaurantId: widget.restaurantId,
            isTablet: isTablet,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerToggle() {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        icon: const Icon(Icons.menu_open),
        onPressed: () => setState(() => isDrawerOpen = false),
      ),
    );
  }

  Widget _buildAllMenuButton(bool isTablet) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedCategory = 'ALL';
          selectedCategoryId = '';
          selectedSubCategory = '';
        });
        _loadAllMenuItems();
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
              color:
                  selectedCategory == 'ALL' ? Colors.green : Colors.grey[600],
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
    );
  }

  Widget _buildCategoriesList(bool isTablet) {
    return BlocBuilder<GetCategorySubcategoryBloc, GetCategorySubcategoryState>(
      builder: (context, state) {
        if (state is GetCategorySubcategoryLoading) {
          return const Center(child: CircularProgressIndicator());
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
          return state.categories.isEmpty
              ? _buildEmptyCategoriesMessage(isTablet)
              : ListView.builder(
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) => _buildExpandableCategory(
                      state.categories[index], isTablet),
                );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyCategoriesMessage(bool isTablet) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            color: Colors.grey[400],
            size: 32,
          ),
          const SizedBox(height: 16),
          Text(
            'No Categories Available',
            style: TextStyle(
              fontSize: isTablet ? 14 : 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add categories using the button below',
            style: TextStyle(
              fontSize: isTablet ? 12 : 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () {
              // Handle category addition logic
            },
            icon: Icon(
              Icons.add_circle_outline,
              size: isTablet ? 18 : 20,
              color: Colors.green,
            ),
            label: Text(
              'Add Category',
              style: TextStyle(
                fontSize: isTablet ? 13 : 14,
                color: Colors.green,
              ),
            ),
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
              selectedCategoryId = category.id;
              selectedSubCategory = '';
            });
            _loadCategoryDishes(category.id);
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
                // Add edit button
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: isTablet ? 18 : 20,
                    color: Colors.grey[600],
                  ),
                  onPressed: () async {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (context) => EditCategoryDialog(
                        categoryId: category.id,
                        restaurantId:
                            widget.restaurantId, // Make sure this is available
                        currentName: category.name,
                      ),
                    );

                    if (result == true) {
                      // Refresh categories list
                      _initializeData();
                    }
                  },
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
            return const SizedBox();
          }),
      ],
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
                    showDialog(
                      context: context,
                      builder: (context) => BlocProvider(
                        create: (context) => CreateDishBloc(
                          CreateNewDishUseCase(
                            DishRepository(
                              DishApiService(),
                            ),
                          ),
                        ),
                        child: CreateDishDialog(
                          restaurantId:
                              widget.restaurantId, // Pass your restaurant ID
                          menuId: menuId, // Pass your menu ID
                        ),
                      ),
                    );

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
    menuId = menuData.menu.first.id;
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
            crossAxisCount = 6;
            spacing = 32;
          } else if (constraints.maxWidth >= 1400) {
            crossAxisCount = 5;
            spacing = 28;
          } else {
            crossAxisCount = 4;
            spacing = 20;
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
              price: '\$${dish.nutritionFacts.calories.toString()}',
              calories: dish.nutritionFacts.calories.toString(),
              protein: dish.nutritionFacts.protein.value.toString(),
              carbs: dish.nutritionFacts.totalCarbohydrates.toString(),
              fat: dish.nutritionFacts.totalFat.value.toString(),
              image: dish.image,
              onTap: () {},
              onEdit: () async {
                await showDialog<Map<String, dynamic>>(
                  context: context,
                  builder: (context) {
                    return DishEditDialog(
                      dishId: dish.id,
                      menuId: menuData.menu.first.id,
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
