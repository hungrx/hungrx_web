// lib/presentation/pages/menu_search/menu_search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_web/data/models/menu_models/menu_search_response.dart';
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
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialQuery.isNotEmpty) {
        _performSearch();
      }
    });
  }

  void _scrollListener() {
    if (!mounted) return;
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
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    context.read<MenuSearchBloc>().add(
          MenuSearchQuerySubmitted(
            query: query,
            restaurantId: widget.restaurantId,
          ),
        );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchHeader(),
            Expanded(
              child: Stack(
                children: [
                  _buildSearchResults(),
                  if (_showScrollToTop)
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: FloatingActionButton(
                        mini: true,
                        onPressed: _scrollToTop,
                        child: const Icon(Icons.arrow_upward),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
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
                              setState(() {});
                            },
                          )
                        : null,
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
                  style: Theme.of(context).textTheme.bodyMedium,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<MenuSearchBloc, MenuSearchState>(
      builder: (context, state) {
        if (state is MenuSearchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is MenuSearchError) {
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
                  'Error',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.red[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _performSearch,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        if (state is MenuSearchEmpty) {
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
                  state.message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        }

          if (state is MenuSearchSuccess) {
        debugPrint('Restaurant: ${state.response.data.restaurant.name}');
        debugPrint('Total Results: ${state.response.data.totalResults}');
        
        if (!state.response.data.hasValidResults()) {
          return const Center(
            child: Text('No matching dishes found'),
          );
        }
        
        return _buildResultsGrid(state.response);
      }
          if (state is MenuSearchEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        );
      }

        // Initial state
        return const Center(
          child: Text('Enter a search term to begin'),
        );
      },
    );
  }

  Widget _buildResultsGrid(MenuSearchResponse response) {

debugPrint('Building results grid with:');
  debugPrint('Restaurant: ${response.data.restaurant.name}');
  debugPrint('Total Results: ${response.data.totalResults}');
  debugPrint('Sections: ${response.data.results.length}');
  
  for (var section in response.data.results) {
    debugPrint('Section: ${section.menuName}, Dishes: ${section.dishes.length}');
    for (var dish in section.dishes) {
      debugPrint('- Dish: ${dish.name}');
    }
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
           if (response.data.results.isEmpty) {
        return const Center(
          child: Text('No results found'),
        );
      }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: response.data.results.length,
          itemBuilder: (context, sectionIndex) {
            final section = response.data.results[sectionIndex];
            if (section.dishes.isEmpty) {
            debugPrint('Section ${section.menuName} has no dishes');
            return const SizedBox.shrink();
          }

            if (section.dishes.isEmpty) return const SizedBox.shrink();



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
                      key: ValueKey(dish.id),
                      name: dish.name,
                      price: '\$${(dish.nutritionFacts.calories / 100).toStringAsFixed(2)}',
                      calories: '${dish.nutritionFacts.calories} cal',
                      protein: '${dish.nutritionFacts.protein.value}g',
                      carbs: '${dish.nutritionFacts.totalCarbohydrates.value}g',
                      fat: '${dish.nutritionFacts.totalFat.value}g',
                      image: dish.image,
                      onTap: () => context.pushNamed(
                        'dishDetails',
                        pathParameters: {'id': dish.id},
                      ),
                      onEdit: () => context.pushNamed(
                        'editDish',
                        pathParameters: {'id': dish.id},
                      ),
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