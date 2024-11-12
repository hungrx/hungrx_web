// lib/presentation/pages/menu_search/menu_search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_web/data/models/menu_search_response.dart';
import 'package:hungrx_web/presentation/bloc/menu_search/menu_search_bloc.dart';
import 'package:hungrx_web/presentation/bloc/menu_search/menu_search_event.dart';
import 'package:hungrx_web/presentation/bloc/menu_search/menu_search_state.dart';
import 'package:hungrx_web/presentation/pages/menu_page/widget/dish_card_widget.dart';


class MenuSearchScreen extends StatefulWidget {
  final String restaurantId;
  final String initialQuery;

  const MenuSearchScreen({
    super.key,
    required this.restaurantId,
    required this.initialQuery,
  });

  @override
  State<MenuSearchScreen> createState() => _MenuSearchScreenState();
}

class _MenuSearchScreenState extends State<MenuSearchScreen> {
  late TextEditingController _searchController;
  late ScrollController _scrollController;
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _performSearch();
  }

  void _scrollListener() {
    setState(() {
      _showScrollToTop = _scrollController.offset > 200;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _performSearch() {
    if (_searchController.text.trim().isEmpty) return;
    
    context.read<MenuSearchBloc>().add(
          MenuSearchQuerySubmitted(
            query: _searchController.text,
            restaurantId: widget.restaurantId,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              _buildSearchHeader(),
              Expanded(
                child: BlocBuilder<MenuSearchBloc, MenuSearchState>(
                  builder: (context, state) {
                    if (state is MenuSearchLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is MenuSearchError) {
                      return MenuSearchError(
                        message: "fail",
                        onRetry: _performSearch,
                      );
                    } else if (state is MenuSearchSuccess) {
                      return _buildSearchResults(state.response);
                    }
                    return const MenuSearchEmpty();
                  },
                ),
              ),
            ],
          ),
          if (_showScrollToTop)
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton(
                mini: true,
                onPressed: () {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Icon(Icons.arrow_upward),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search menu items...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _performSearch();
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  onSubmitted: (_) => _performSearch(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          BlocBuilder<MenuSearchBloc, MenuSearchState>(
            builder: (context, state) {
              if (state is MenuSearchSuccess) {
                return Text(
                  '${state.response.data.totalResults} results found',
                  style: Theme.of(context).textTheme.bodySmall,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(MenuSearchResponse response) {
    if (response.data.results.isEmpty) {
      return const MenuSearchEmpty();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1200;
        final isTablet = constraints.maxWidth >= 768 && constraints.maxWidth < 1200;
        
        int crossAxisCount;
        if (isDesktop) {
          crossAxisCount = 4;
        } else if (isTablet) {
          crossAxisCount = 3;
        } else {
          crossAxisCount = 2;
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: response.data.results.length,
          itemBuilder: (context, sectionIndex) {
            final section = response.data.results[sectionIndex];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    section.menuName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: section.dishes.length,
                  itemBuilder: (context, dishIndex) {
                    final dish = section.dishes[dishIndex];
                    return DishCard(
                      name: dish.name,
                      price: '\$${(dish.nutritionFacts.calories / 100).toStringAsFixed(2)}',
                      calories: '${dish.nutritionFacts.calories} cal',
                      protein: '${dish.nutritionFacts.protein.value}g',
                      carbs: '${dish.nutritionFacts.totalCarbohydrates.value}g',
                      fat: '${dish.nutritionFacts.totalFat.value}g',
                      image: dish.image,
                      onTap: () {
                        // Navigate to dish details
                        context.pushNamed(
                          'dishDetails',
                          pathParameters: {'id': dish.id},
                        );
                      },
                      onEdit: () {
                        // Navigate to edit dish
                        context.pushNamed(
                          'editDish',
                          pathParameters: {'id': dish.id},
                        );
                      },
                    );
                  },
                ),
                if (sectionIndex < response.data.results.length - 1)
                  const Divider(height: 32),
              ],
            );
          },
        );
      },
    );
  }
}

// lib/presentation/widgets/menu_search/menu_search_empty.dart
class MenuSearchEmpty extends StatelessWidget {
  const MenuSearchEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

// lib/presentation/widgets/menu_search/menu_search_error.dart
class MenuSearchError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const MenuSearchError({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}