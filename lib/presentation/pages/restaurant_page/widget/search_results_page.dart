import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_web/core/widgets/custom_navbar.dart';
import 'package:hungrx_web/data/datasource/api/resturant_api/search_restaurant_api.dart';
import 'package:hungrx_web/data/models/restaurant_models/category_model.dart';
import 'package:hungrx_web/data/repositories/restaurant_repo/search_restaurant_repository.dart';
import 'package:hungrx_web/domain/usecase/restaurant_usecase/search_restaurants_usecase.dart';
import 'package:hungrx_web/presentation/bloc/restuarant_category/restuarant_category_bloc.dart';
import 'package:hungrx_web/presentation/bloc/restuarant_category/restuarant_category_state.dart';
import 'package:hungrx_web/presentation/bloc/search_restaurants/search_restaurants_bloc.dart';
import 'package:hungrx_web/presentation/bloc/search_restaurants/search_restaurants_event.dart';
import 'package:hungrx_web/presentation/bloc/search_restaurants/search_restaurants_state.dart';
import 'package:hungrx_web/presentation/layout/app_layout.dart';
import 'package:hungrx_web/presentation/pages/restaurant_page/widget/restaurant_card_widget.dart';

class SearchResultsPage extends StatelessWidget {

  final String searchQuery;

  const SearchResultsPage({
    super.key,
    required this.searchQuery,
   
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchRestaurantBloc(
        SearchRestaurantsUseCase(
          SearchRestaurantRepository(
            SearchRestaurantApi(),
          ),
        ),
      )..add(SearchRestaurantSubmitted(searchQuery)),
      child:  const SearchResultsView(
        
      ),
    );
  }
}

class SearchResultsView extends StatelessWidget {

  const SearchResultsView({super.key,});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentItem: NavbarItem.restaurant,
      child: BlocBuilder<SearchRestaurantBloc, SearchRestaurantState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, state),
                const SizedBox(height: 24),
                Expanded(
                  child: _buildContent(context, state),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, SearchRestaurantState state) {
    String title = 'Search Results';
    if (state is SearchRestaurantSuccess) {
      title = 'Search Results for "${state.searchQuery}"';
    }

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        const SizedBox(width: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

Widget _buildContent(BuildContext context, SearchRestaurantState state) {
    if (state is SearchRestaurantLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is SearchRestaurantError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${state.message}',
              style: TextStyle(color: Colors.red[700]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<SearchRestaurantBloc>().add(
                    SearchRestaurantSubmitted(state.searchQuery),
                  ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is SearchRestaurantSuccess) {
      if (state.restaurants.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No restaurants found for "${state.searchQuery}"',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }

      return BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, categoryState) {
          List<CategoryModel> categories = 
              categoryState is CategoryLoaded ? categoryState.categories : [];

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.5,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
            ),
            itemCount: state.restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = state.restaurants[index];
              return RestaurantCard(
                id: restaurant.id,
                name: restaurant.name,
                logo: restaurant.logo,
                category: restaurant.category?.name ?? 'Uncategorized',
                rating: restaurant.rating.toString(),
                descrioption: restaurant.description ?? '',
                categories: categories,
                createdAt: restaurant.createdAt ??'',
                updatedAt: restaurant.updatedAt??'',
                onUpdateSuccess: () {
                  // Refresh search results after update
                  context.read<SearchRestaurantBloc>().add(
                    SearchRestaurantSubmitted(state.searchQuery),
                  );
                },
              );
            },
          );
        },
      );
    }

    return const SizedBox.shrink();
  }

}
