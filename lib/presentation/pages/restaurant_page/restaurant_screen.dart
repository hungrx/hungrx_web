import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/core/widgets/custom_header.dart';
import 'package:hungrx_web/core/widgets/custom_navbar.dart';
import 'package:hungrx_web/data/models/category_model.dart';
import 'package:hungrx_web/presentation/bloc/add_restaurant/add_restaurant_bloc.dart';
import 'package:hungrx_web/presentation/bloc/restaurant_display/restaurant_disply_bloc.dart';
import 'package:hungrx_web/presentation/bloc/restaurant_display/restaurant_disply_event.dart';
import 'package:hungrx_web/presentation/bloc/restaurant_display/restaurant_disply_state.dart';
import 'package:hungrx_web/presentation/bloc/restuarant_category/restuarant_category_bloc.dart';
import 'package:hungrx_web/presentation/bloc/restuarant_category/restuarant_category_event.dart';
import 'package:hungrx_web/presentation/bloc/restuarant_category/restuarant_category_state.dart';
import 'package:hungrx_web/presentation/layout/app_layout.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hungrx_web/presentation/pages/restaurant_page/widget/add_category_dialog.dart';
import 'package:hungrx_web/presentation/pages/restaurant_page/widget/add_restaurant_widget.dart';
import 'package:hungrx_web/presentation/pages/restaurant_page/widget/restaurant_card_widget.dart';

class RestaurantScreen extends HookWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedCategory = useState<CategoryModel?>(null);

    useEffect(() {
      context.read<RestaurantBloc>().add(FetchRestaurants());
      context.read<CategoryBloc>().add(FetchCategories());
      return null;
    }, []);

    return AppLayout(
      currentItem: NavbarItem.restaurant,
      child: MultiBlocListener(
        listeners: [
          BlocListener<RestaurantBloc, RestaurantState>(
            listener: (context, state) {
              if (state is RestaurantError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
          ),
          BlocListener<CategoryBloc, CategoryState>(
            listener: (context, state) {
              if (state is CategoryError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
          ),
        ],
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 1200;
            final isTablet = constraints.maxWidth < 1200;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSideDrawer(
                  context,
                  selectedCategory,
                  width: isTablet ? 200 : 250,
                ),
                Expanded(
                  child: BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) => _buildMainContent(
                      context,
                      state: state,
                      isDesktop: isDesktop,
                      isTablet: isTablet,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSideDrawer(
    BuildContext context,
    ValueNotifier<CategoryModel?> selectedCategory, {
    required double width,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CategoryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading categories',
                    style: TextStyle(color: Colors.red[700]),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<CategoryBloc>().add(FetchCategories()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is CategoryLoaded) {
            final categories = state.categories;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return _buildCategoryItem(category, selectedCategory);
                    },
                  ),
                ),
                _buildNewCategoryButton(context),
              ],
            );
          }

          return const Center(child: Text('No categories found'));
        },
      ),
    );
  }

  Widget _buildCategoryItem(
    CategoryModel category,
    ValueNotifier<CategoryModel?> selectedCategory,
  ) {
    final isSelected = category.id == selectedCategory.value?.id;
    return InkWell(
      onTap: () => selectedCategory.value = category,
      child: Container(
        color: isSelected ? Colors.green.shade100 : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          category.name ??'',
          style: TextStyle(
            color: isSelected ? Colors.green : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildNewCategoryButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const AddCategoryDialog(),
          );
        },
        icon: const Icon(Icons.add, size: 18),
        label: const Text(
          'NEW CATEGORY',
          style: TextStyle(fontSize: 13),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(
    BuildContext context, {
    required CategoryState state,
    required bool isDesktop,
    required bool isTablet,
  }) {
    return Padding(
      padding: EdgeInsets.all(isTablet ? 16.0 : 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomHeader(
            title: 'ALL RESTAURANT',
            searchHint: 'Search restaurant...',
            buttonLabel: 'ADD RESTAURANT',
            isTablet: isTablet,
            onAddPressed: () {
              if (state is CategoryLoaded && state.categories.isNotEmpty) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => BlocProvider.value(
                    value: context.read<AddRestaurantBloc>(),
                    child: AddRestaurantDialog(
                      categories: state.categories,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Please add at least one category before adding a restaurant',
                    ),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            onSearchChanged: (value) {
              // Handle search
            },
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _buildRestaurantGrid(isDesktop, isTablet),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantGrid(
    bool isDesktop,
    bool isTablet,
  ) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RestaurantBloc, RestaurantState>(
          listener: (context, state) {
            // Handle RestaurantBloc-specific actions here if needed
          },
        ),
        BlocListener<CategoryBloc, CategoryState>(
          listener: (context, state) {
            // Handle CategoryBloc-specific actions here if needed
          },
        ),
      ],
      child: BlocBuilder<RestaurantBloc, RestaurantState>(
        builder: (context, restaurantState) {
          if (restaurantState is RestaurantLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (restaurantState is RestaurantError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading restaurants',
                    style: TextStyle(color: Colors.red[700]),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<RestaurantBloc>().add(FetchRestaurants()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (restaurantState is RestaurantLoaded) {
            return BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, categoryState) {
                List<CategoryModel> categories = []; // Default empty categories

                if (categoryState is CategoryLoaded) {
                  categories = categoryState.categories;
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount;
                    if (isDesktop) {
                      crossAxisCount = constraints.maxWidth > 1500 ? 4 : 3;
                    } else {
                      crossAxisCount = constraints.maxWidth > 800 ? 2 : 1;
                    }

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: isTablet ? 1.3 : 1.5,
                        crossAxisSpacing: isTablet ? 16 : 24,
                        mainAxisSpacing: isTablet ? 16 : 24,
                      ),
                      itemCount: restaurantState.restaurants.length,
                      itemBuilder: (context, index) {
                        final restaurant = restaurantState.restaurants[index];
                        return RestaurantCard(
                          categories: categories,
                          updatedAt: restaurant.updatedAt ?? "",
                          category: restaurant.category?.id ?? "",
                          createdAt: restaurant.createdAt ?? "",
                          descrioption: restaurant.description ?? "",
                          id: restaurant.id,
                          rating: restaurant.rating.toString(),
                          name: restaurant.name,
                          logo: restaurant.logo,
                          onUpdateSuccess: () {
                            context
                                .read<RestaurantBloc>()
                                .add(FetchRestaurants());
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          }

          return const Center(child: Text('No restaurants found'));
        },
      ),
    );
  }
}
