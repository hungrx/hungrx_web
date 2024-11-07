// File: lib/presentation/pages/search/search_landing_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchLandingScreen extends StatelessWidget {
  const SearchLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _buildMainContent(context, constraints),
              ),
              _buildFooter(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => context.go('/'),
              child: Image.asset(
                'assets/images/logo.png',
                height: 40,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.restaurant, color: Colors.green),
                  );
                },
              ),
            ),
          ),
          Row(
            children: [
              _buildNavButton(
                context,
                'Apps',
                onPressed: () => context.push('/apps'),
              ),
              const SizedBox(width: 24),
              _buildNavButton(
                context,
                'hungrX Lab',
                onPressed: () => context.push('/admin'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context,
    String label, {
    required VoidCallback onPressed,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, BoxConstraints constraints) {
    // Calculate responsive widths
    final maxWidth = constraints.maxWidth;
    final searchBarWidth = maxWidth < 600 ? maxWidth * 0.9 : 600.0;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo and company name
            const Text(
              'hungrX',
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 48),
            // Search bar
            Container(
              width: searchBarWidth,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Food...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    context.push('/search-results?query=$value');
                  }
                },
              ),
            ),
            const SizedBox(height: 24),
            // Search caption
            const Text(
              'Find nutrition facts for your favorite foods. Search to start!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.grey.shade100,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return _buildMobileFooter(context);
          }
          return _buildDesktopFooter(context);
        },
      ),
    );
  }

  Widget _buildDesktopFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'hungrx.com',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        Row(
          children: [
            _buildFooterLink(
              context,
              'Privacy and Policy',
              onPressed: () => context.push('/privacy'),
            ),
            const SizedBox(width: 24),
            _buildFooterLink(
              context,
              'Terms and Conditions',
              onPressed: () => context.push('/terms'),
            ),
            const SizedBox(width: 24),
            _buildFooterLink(
              context,
              'Disclaimer',
              onPressed: () => context.push('/disclaimer'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileFooter(BuildContext context) {
    return Column(
      children: [
        const Text(
          'hungrx.com',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            _buildFooterLink(
              context,
              'Privacy and Policy',
              onPressed: () => context.push('/privacy'),
            ),
            const SizedBox(height: 12),
            _buildFooterLink(
              context,
              'Terms and Conditions',
              onPressed: () => context.push('/terms'),
            ),
            const SizedBox(height: 12),
            _buildFooterLink(
              context,
              'Disclaimer',
              onPressed: () => context.push('/disclaimer'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooterLink(
    BuildContext context,
    String label, {
    required VoidCallback onPressed,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.grey[600],
          minimumSize: Size.zero,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}