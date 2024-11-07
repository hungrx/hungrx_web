import 'package:flutter/material.dart';
import 'package:hungrx_web/core/widgets/custom_header.dart';
import 'package:hungrx_web/core/widgets/custom_navbar.dart';
import 'package:hungrx_web/presentation/layout/app_layout.dart';
import 'package:hungrx_web/presentation/pages/grocery_page/widgets/brand_card_widget.dart';

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentItem: NavbarItem.grocery,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 1200;
          final isTablet = constraints.maxWidth < 1200;

          return Padding(
            padding: EdgeInsets.all(isTablet ? 16.0 : 24.0),
            child: _buildMainContent(context,
                isDesktop: isDesktop, isTablet: isTablet),
          );
        },
      ),
    );
  }

  Widget _buildMainContent(
    BuildContext context, {
    required bool isDesktop,
    required bool isTablet,
  }) {
    return Column(
      children: [
        CustomHeader(
                  title: 'ALL BRANDS',
                  searchHint: 'Search brands...',
                  buttonLabel: 'ADD BRANDS',
                  isTablet: isTablet,
                  onAddPressed: () {
                    // Handle add button press
                  },
                  onSearchChanged: (value) {
                    // Handle search
                  },
                ),
        SizedBox(height: isTablet ? 24 : 32),
        Expanded(
          child: _buildBrandsGrid(context, isDesktop, isTablet),
        ),
      ],
    );
  }

Widget _buildHeader(BuildContext context, bool isTablet) {
  return SizedBox(
    width: double.infinity,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left side - Header Text
        Text(
          'ALL BRANDS',
          style: TextStyle(
            fontSize: isTablet ? 24 : 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        // Right side - Search and Add Button
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isTablet ? 400 : 500,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: SizedBox(
                  width: isTablet ? 200 : 300,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search brands...',
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
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => _showAddBrandDialog(context),
                icon: const Icon(Icons.add),
                label: Text(
                  isTablet ? 'ADD' : 'ADD BRAND',
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
        ),
      ],
    ),
  );
}

  Widget _buildBrandsGrid(BuildContext context, bool isDesktop, bool isTablet) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate number of columns based on screen width
        int crossAxisCount;
        double spacing;

        if (isDesktop) {
          if (constraints.maxWidth >= 1800) {
            crossAxisCount = 8; // Extra large screens
            spacing = 32;
          } else if (constraints.maxWidth >= 1500) {
            crossAxisCount = 7; // Large desktop
            spacing = 28;
          } else {
            crossAxisCount = 6; // Regular desktop
            spacing = 24;
          }
        } else {
          if (constraints.maxWidth >= 1000) {
            crossAxisCount = 5; // Large tablet
            spacing = 20;
          } else if (constraints.maxWidth >= 800) {
            crossAxisCount = 4; // Medium tablet
            spacing = 16;
          } else {
            crossAxisCount = 3; // Small tablet
            spacing = 12;
          }
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing / 2),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 1,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
            ),
            itemCount: 18,
            itemBuilder: (context, index) {
              return const BrandCard(
                brandName: 'NESTLE',
                logoPath: 'assets/images/nestle_logo.png',
                lastUpdate: '12/20/2024 12:32 AM',
              );
            },
          ),
        );
      },
    );
  }

  void _showAddBrandDialog(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width < 1200;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: isTablet ? screenSize.width * 0.8 : screenSize.width * 0.4,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add New Brand',
                    style: TextStyle(
                      fontSize: isTablet ? 20 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Brand Name',
                  hintText: 'Enter brand name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                height: isTablet ? 120 : 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: isTablet ? 32 : 40,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Click to upload brand logo',
                      style: TextStyle(
                        fontSize: isTablet ? 11 : 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
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
                      // Handle adding new brand
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Add Brand'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
