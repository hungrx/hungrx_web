import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/data/datasource/api/menu_api/add_food_category_api.dart';
import 'package:hungrx_web/data/datasource/api/menu_api/dish_api_service.dart';
import 'package:hungrx_web/data/datasource/api/menu_api/quick_search_api.dart';
import 'package:hungrx_web/data/repositories/menu_repo/add_food_category_repository.dart';
import 'package:hungrx_web/data/repositories/menu_repo/dish_repository.dart';
import 'package:hungrx_web/data/repositories/menu_repo/quick_search_repository.dart';
import 'package:hungrx_web/data/models/menu_models/quick_search_response.dart';
import 'package:hungrx_web/domain/usecase/manu_usecase/create_new_dish_usecase.dart';
import 'package:hungrx_web/presentation/bloc/add_food_to_category/add_food_to_category_bloc.dart';
import 'package:hungrx_web/presentation/bloc/create_new_dish/create_new_dish_bloc.dart';
import 'package:hungrx_web/presentation/bloc/get_dishes_by%20category/get_dishes_by_category_bloc.dart';
import 'package:hungrx_web/presentation/bloc/get_dishes_by%20category/get_dishes_by_category_event.dart';
import 'package:hungrx_web/presentation/bloc/menu_quick_search/menu_quick_search_dialog_bloc.dart';
import 'package:hungrx_web/presentation/bloc/menu_quick_search/menu_quick_search_dialog_event.dart';
import 'package:hungrx_web/presentation/bloc/menu_quick_search/menu_quick_search_dialog_state.dart';
import 'package:hungrx_web/presentation/pages/menu_page/widget/create_dish_dialog.dart';
import 'package:hungrx_web/presentation/pages/menu_page/widget/dish_add_button_in_dialog.dart';

class FoodSearchDialog extends StatelessWidget {
  final String restaurantId;
  final String menuId;
  final String categoryId;
  final String? subcategoryId;
  final Function(DishItem) onFoodSelected;

  const FoodSearchDialog({
    super.key,
    required this.restaurantId,
    required this.menuId,
    required this.categoryId,
    this.subcategoryId,
    required this.onFoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 800,
          maxHeight: 600,
        ),
        child: MultiBlocProvider(
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
          child: FoodSearchContent(
            restaurantId: restaurantId,
            menuId: menuId,
            categoryId: categoryId,
            subcategoryId: subcategoryId,
            onFoodSelected: onFoodSelected,
          ),
        ),
      ),
    );
  }
}

// Content Widget
class FoodSearchContent extends StatefulWidget {
  final String restaurantId;
  final String menuId;
  final String categoryId;
  final String? subcategoryId;
  final Function(DishItem) onFoodSelected;

  const FoodSearchContent({
    super.key,
    required this.restaurantId,
    required this.menuId,
    required this.categoryId,
    this.subcategoryId,
    required this.onFoodSelected,
  });

  @override
  State<FoodSearchContent> createState() => _FoodSearchContentState();
}

class _FoodSearchContentState extends State<FoodSearchContent> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Request focus when dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<QuickSearchBloc>().add(
            SearchDishesEvent(
              query: query,
              restaurantId: widget.restaurantId,
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(),
        _buildSearchBar(),
        const Expanded(
          child: _SearchResults(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Expanded(
            child: Text(
              'ADD FOOD TO CATEGORY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
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
                    menuId: widget.menuId, // Pass your menu ID
                  ),
                ),
              );

              // Handle adding new dish
            },
            icon: const Icon(Icons.create),
            label: const Text(
              'CREATE DISH',
              style: TextStyle(fontSize: 14),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 7, 61, 10),
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
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocus,
        decoration: InputDecoration(
          hintText: 'SEARCH FOOD....',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<QuickSearchBloc>().add(
                          SearchDishesEvent(
                            query: '',
                            restaurantId: widget.restaurantId,
                          ),
                        );
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }
}

// Search Results Widget
class _SearchResults extends StatelessWidget {
  const _SearchResults();

  @override
  Widget build(BuildContext context) {
    final foodSearchContent =
        context.findAncestorWidgetOfExactType<FoodSearchContent>();
    if (foodSearchContent == null) return const SizedBox.shrink();

    return BlocBuilder<QuickSearchBloc, QuickSearchState>(
      builder: (context, state) {
        if (state is QuickSearchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is QuickSearchError) {
          return _buildErrorState(context, state.message);
        }

        if (state is QuickSearchSuccess) {
          if (state.dishes.isEmpty) {
            return _buildEmptyState();
          }

          return _buildSearchResults(
            context,
            state.dishes,
            foodSearchContent.restaurantId,
            foodSearchContent.menuId,
            foodSearchContent.categoryId,
            foodSearchContent.subcategoryId,
          );
        }

        // Initial state
        return const Center(
          child: Text(
            'Start typing to search foods',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final bloc = context.read<QuickSearchBloc>();
              if (bloc.state is QuickSearchError) {
                final foodSearchContent =
                    context.findAncestorWidgetOfExactType<FoodSearchContent>();
                if (foodSearchContent != null) {
                  bloc.add(SearchDishesEvent(
                    query: '',
                    restaurantId: foodSearchContent.restaurantId,
                  ));
                }
              }
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No foods found',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(
    BuildContext context,
    List<DishItem> dishes,
    String restaurantId,
    String menuId,
    String categoryId,
    String? subcategoryId,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dishes.length,
      itemBuilder: (context, index) {
        final dish = dishes[index];
        return FoodSearchTile(
          index: index,
          dish: dish,
          restaurantId: restaurantId,
          menuId: menuId,
          categoryId: categoryId,
          subcategoryId: subcategoryId,
        );
      },
    );
  }
}

// Food Search Tile Widget
class FoodSearchTile extends StatefulWidget {
  final int index;
  final DishItem dish;
  final String restaurantId;
  final String menuId;
  final String categoryId;
  final String? subcategoryId;

  const FoodSearchTile({
    super.key,
    required this.dish,
    required this.restaurantId,
    required this.menuId,
    required this.categoryId,
    this.subcategoryId,
    required this.index,
  });

  @override
  State<FoodSearchTile> createState() => _FoodSearchTileState();
}

class _FoodSearchTileState extends State<FoodSearchTile> {
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: _buildDishImage(),
        title: Text(
          widget.dish.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: _buildSubtitle(),
        trailing: _buildAddButton(context, widget.index),
      ),
    );
  }

  Widget _buildDishImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        widget.dish.image,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 80,
            height: 80,
            color: Colors.grey.shade200,
            child: const Icon(Icons.fastfood),
          );
        },
      ),
    );
  }

  Widget _buildSubtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Menu: ${widget.dish.menuName}',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        if (widget.dish.category != null)
          Wrap(
            spacing: 8,
            children: [
              _buildCategoryChip(widget.dish.category!),
              if (widget.dish.subcategory != null)
                _buildCategoryChip(widget.dish.subcategory!,
                    isSubCategory: true),
            ],
          ),
      ],
    );
  }

  Widget _buildCategoryChip(String category, {bool isSubCategory = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSubCategory ? Colors.green.shade100 : Colors.blue.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSubCategory ? Colors.green : Colors.blue,
          width: 1,
        ),
      ),
      child: Text(
        category.toUpperCase(),
        style: TextStyle(
          color: isSubCategory ? Colors.green.shade700 : Colors.blue.shade700,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, int index) {
    return DishAddButton(
      index: index,
      restaurantId: widget.restaurantId,
      menuId: widget.menuId,
      categoryId: widget.categoryId,
      subcategoryId: widget.subcategoryId,
      dish: widget.dish,
      onDishAdded: () => _loadCategoryDishes(widget.categoryId),
    );
  }
}
