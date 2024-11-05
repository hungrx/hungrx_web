// File: lib/routes/app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_web/presentation/pages/common_food_page/common_food_screen.dart';
import 'package:hungrx_web/presentation/pages/dashboard_page/dashboard_screen.dart';
import 'package:hungrx_web/presentation/pages/grocery_page/grocery_screen.dart';
import 'package:hungrx_web/presentation/pages/login_page/login_screen.dart';
import 'package:hungrx_web/presentation/pages/menu_page/restaurant_menu_screen.dart';
import 'package:hungrx_web/presentation/pages/otp_verifiacation/otp_verification_screen.dart';
import 'package:hungrx_web/presentation/pages/restaurant_page/restaurant_screen.dart';
import 'route_names.dart';

// Import other pages as needed

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
        path: '/otp-verification/:phoneNumber/:name',  // Updated path with both parameters
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
            path: RouteNames.dashboard,
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/restaurant-menu/:name',
            name: 'restaurant-menu',
            builder: (context, state) => RestaurantMenuScreen(
              restaurantName: state.pathParameters['name'] ?? '',
            ),
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
