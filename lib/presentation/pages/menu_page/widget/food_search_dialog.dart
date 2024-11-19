import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/data/models/menu_models/search_food_model.dart';
import 'package:hungrx_web/presentation/bloc/search_food_dialog/search_food_dialog_bloc.dart';
import 'package:hungrx_web/presentation/bloc/search_food_dialog/search_food_dialog_event.dart';
import 'package:hungrx_web/presentation/bloc/search_food_dialog/search_food_dialog_state.dart';

class FoodSearchDialog extends StatelessWidget {
  const FoodSearchDialog({super.key});

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
        child: const FoodSearchContent(),
      ),
    );
  }
}

class FoodSearchContent extends StatefulWidget {
  const FoodSearchContent({super.key});

  @override
  State<FoodSearchContent> createState() => _FoodSearchContentState();
}

class _FoodSearchContentState extends State<FoodSearchContent> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(),
        _buildSearchBar(),
        const Expanded(
          child: FoodSearchResults(),
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
      child: const Text(
        'ADD FOOD TO CATEGORY',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
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
        onChanged: (value) {
          // Trigger search event in BLoC
          context.read<FoodSearchBloc>().add(SearchFoodEvent(query: value));
        },
      ),
    );
  }
}

class FoodSearchResults extends StatelessWidget {
  const FoodSearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodSearchBloc, FoodSearchState>(
      builder: (context, state) {
        if (state is FoodSearchLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is FoodSearchError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is FoodSearchSuccess) {
          if (state.foods.isEmpty) {
            return const Center(
              child: Text('No foods found'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.foods.length,
            itemBuilder: (context, index) {
              final food = state.foods[index];
              return FoodSearchTile(food: food);
            },
          );
        }

        return const Center(
          child: Text('Start typing to search foods'),
        );
      },
    );
  }
}

class FoodSearchTile extends StatelessWidget {
  final Food food;

  const FoodSearchTile({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            food.imageUrl,
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
        ),
        title: Text(
          food.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last updated: ${food.lastUpdated}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            if (food.category != null)
              Wrap(
                spacing: 8,
                children: [
                  _buildCategoryChip(food.category!),
                  if (food.subCategory != null)
                    _buildCategoryChip(food.subCategory!, isSubCategory: true),
                ],
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle),
          color: Theme.of(context).primaryColor,
          iconSize: 32,
          onPressed: () {
            // context.read<FoodCategoryBloc>().add(
            //       AddFoodToCategoryEvent(foodId: food.id),
            //     );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category, {bool isSubCategory = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSubCategory ? Colors.green : Colors.red.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        category.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}