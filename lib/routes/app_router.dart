import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_web/data/datasource/api/menu_api/menu_search_api.dart';
import 'package:hungrx_web/data/repositories/menu_repo/menu_search_repository.dart';
import 'package:hungrx_web/presentation/bloc/menu_search/menu_search_bloc.dart';
import 'package:hungrx_web/presentation/pages/common_food_page/common_food_screen.dart';
import 'package:hungrx_web/presentation/pages/dashboard_page/dashboard_screen.dart';
import 'package:hungrx_web/presentation/pages/grocery_page/grocery_screen.dart';
import 'package:hungrx_web/presentation/pages/menu_page/menu_screen.dart';
import 'package:hungrx_web/presentation/pages/menu_page/widget/menu_search_screen.dart';
import 'package:hungrx_web/presentation/pages/otp_verifiacation/otp_verification_screen.dart';
import 'package:hungrx_web/presentation/pages/restaurant_page/restaurant_screen.dart';
import 'package:hungrx_web/presentation/pages/restaurant_page/widget/search_results_page.dart';
import 'route_names.dart';
import 'package:http/http.dart' as http;

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.login,
    routes: [
      // Login and OTP routes remain outside the shell
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/otp-verification/:phoneNumber/:name',
        name: 'otpVerify',
        builder: (context, state) {
          final phoneNumber = state.pathParameters['phoneNumber'] ?? '';
          final name = state.pathParameters['name'] ?? '';
          return OtpVerificationScreen(
            phoneNumber: phoneNumber,
            name: name,
          );
        },
      ),

      // Shell route for authenticated pages with persistent navbar
      ShellRoute(
        builder: (context, state, child) {
          return child;
        },
        routes: [
          GoRoute(
            name: 'menuSearch',
            path: '/restaurants/:restaurantId/search',
            builder: (context, state) {
              final restaurantId = state.pathParameters['restaurantId'] ?? '';
              final query = state.uri.queryParameters['q'] ?? '';

              return BlocProvider(
                create: (context) => MenuSearchBloc(
                  repository: MenuSearchRepository(
                    api: MenuSearchApi(client: http.Client()),
                  ),
                ),
                child: MenuSearchScreen(
                  restaurantId: restaurantId,
                  initialQuery: query,
                ),
              );
            },
          ),
          GoRoute(
            path: RouteNames.dashboard,
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/restaurant-menu/:id/:name',
            name: 'restaurant-menu',
            builder: (context, state) => RestaurantMenuScreen(
              restaurantId: state.pathParameters['id'] ?? '',
              restaurantName: state.pathParameters['name'] ?? '',
            ),
          ),
          GoRoute(
            path: '/search',
            name: 'search',
            builder: (context, state) {
              final query = state.uri.queryParameters['q'] ?? '';
              return SearchResultsPage(searchQuery: query);
            },
          ),
          GoRoute(
            path: '/restaurant',
            name: 'restaurant',
            builder: (context, state) => const RestaurantScreen(),
          ),
          GoRoute(
            path: '/common-food',
            name: 'commonFood',
            builder: (context, state) => const CommonFoodScreen(),
          ),
          GoRoute(
            path: '/grocery',
            name: 'grocery',
            builder: (context, state) => const GroceryScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(
        child: Text('Page not found'),
      ),
    ),
  );
}
