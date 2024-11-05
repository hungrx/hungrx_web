import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/core/widgets/custom_navbar.dart';
import 'package:hungrx_web/presentation/bloc/restaurant_display/restaurant_disply_bloc.dart';
import 'package:hungrx_web/presentation/bloc/restaurant_display/restaurant_disply_event.dart';
import 'package:hungrx_web/presentation/bloc/restaurant_display/restaurant_disply_state.dart';
import 'package:hungrx_web/presentation/layout/app_layout.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hungrx_web/presentation/pages/restaurant_page/widget/restaurant_card_widget.dart';

class RestaurantScreen extends HookWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedCategory = useState('ALL');
    final categories = useState<List<String>>([
      'ALL',
      'CASUAL DINING',
      'FINE DINING',
      'FAST FOOD',
      'BUFFET',
      'CAFÉS'
    ]);

    useEffect(() {
      context.read<RestaurantBloc>().add(FetchRestaurants());
      return null;
    }, []);

    return AppLayout(
      currentItem: NavbarItem.restaurant,
    child: BlocListener<RestaurantBloc, RestaurantState>(
        listener: (context, state) {
          if (state is RestaurantError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Define breakpoints
            final isDesktop = constraints.maxWidth >= 1200;
            final isTablet = constraints.maxWidth < 1200;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSideDrawer(
                  context,
                  selectedCategory,
                  categories,
                  width: isTablet ? 200 : 250,
                ),
                Expanded(
                  child: _buildMainContent(
                    context,
                    isDesktop: isDesktop,
                    isTablet: isTablet,
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
    ValueNotifier<String> selectedCategory,
    ValueNotifier<List<String>> categories, {
    required double width,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: categories.value.length,
              itemBuilder: (context, index) {
                final category = categories.value[index];
                return _buildCategoryItem(category, selectedCategory);
              },
            ),
          ),
          _buildNewCategoryButton(context, categories),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
      String category, ValueNotifier<String> selectedCategory) {
    final isSelected = category == selectedCategory.value;
    return InkWell(
      onTap: () => selectedCategory.value = category,
      child: Container(
        color: isSelected ? Colors.green.shade100 : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.green : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildNewCategoryButton(
      BuildContext context, ValueNotifier<List<String>> categories) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton.icon(
        onPressed: () => _showAddCategoryDialog(context, categories),
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
    required bool isDesktop,
    required bool isTablet,
  }) {
    return Padding(
      padding: EdgeInsets.all(isTablet ? 16.0 : 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, isTablet),
          const SizedBox(height: 24),
          Expanded(
            child: _buildRestaurantGrid(isDesktop, isTablet),
          ),
        ],
      ),
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
          'ALL RESTAURANT',
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
                  hintText: 'Search restaurants...',
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
              onPressed: () {
                // Handle new restaurant
              },
              icon: const Icon(Icons.add),
              label: Text(
                isTablet ? 'NEW' : 'NEW RESTAURANT',
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

 Widget _buildRestaurantGrid(bool isDesktop, bool isTablet) {
    return BlocBuilder<RestaurantBloc, RestaurantState>(
      builder: (context, state) {
        if (state is RestaurantLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is RestaurantError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error loading restaurants',
                  style: TextStyle(color: Colors.red[700]),
                ),
                ElevatedButton(
                  onPressed: () => context.read<RestaurantBloc>().add(FetchRestaurants()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is RestaurantLoaded) {
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
                itemCount: state.restaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = state.restaurants[index];
                  return RestaurantCard(
                    name: restaurant.name,
                    logo: restaurant.logo,
                  );
                },
              );
            },
          );
        }

        return const Center(child: Text('No restaurants found'));
      },
    );
  }



  void _showAddCategoryDialog(
      BuildContext context, ValueNotifier<List<String>> categories) {
    final screenSize = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return Dialog(
          child: Container(
            width: screenSize.width * 0.3,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add New Category',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                    hintText: 'Enter category name',
                    border: OutlineInputBorder(),
                  ),
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
                        if (controller.text.isNotEmpty) {
                          categories.value = [
                            ...categories.value,
                            controller.text.toUpperCase()
                          ];
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}