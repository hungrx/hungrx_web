// File: lib/presentation/pages/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:hungrx_web/core/widgets/custom_navbar.dart';
import 'package:hungrx_web/presentation/layout/app_layout.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentItem: NavbarItem.dashboard,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _buildMainContent(context),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'DASHBOARD',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search foods...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return constraints.maxWidth < 768
                  ? _buildMobileCategories()
                  : _buildDesktopCategories();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopCategories() {
    return Row(
      children: [
        Expanded(child: _buildCategoryCard(
          'RESTAURANTS',
          '820',
          'assets/images/restaurant.jpeg',
          'Manage all your restaurant listings and menus',
          () {},
        )),
        const SizedBox(width: 24),
        Expanded(child: _buildCategoryCard(
          'COMMON FOODS',
          '15820',
          'assets/images/commonfood.png',
          'Browse and manage common food items',
          () {},
        )),
        const SizedBox(width: 24),
        Expanded(child: _buildCategoryCard(
          'GROCERIES',
          '25820',
          'assets/images/grocerry.jpg',
          'Manage your grocery inventory and prices',
          () {},
        )),
      ],
    );
  }

  Widget _buildMobileCategories() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCategoryCard(
            'RESTAURANTS',
            '820',
            'assets/images/restaurant.jpeg',
            'Manage all your restaurant listings and menus',
            () {},
          ),
          const SizedBox(height: 24),
          _buildCategoryCard(
            'COMMON FOODS',
            '15820',
            'assets/images/foods.png',
            'Browse and manage common food items',
            () {},
          ),
          const SizedBox(height: 24),
          _buildCategoryCard(
            'GROCERIES',
            '25820',
            'assets/images/grocerry.jpg',
            'Manage your grocery inventory and prices',
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    String title,
    String count,
    String imagePath,
    String description,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Section
            SizedBox(
              height: 200,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image, size: 50),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      count,
                      style: const TextStyle(
                        fontSize: 90,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
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
}