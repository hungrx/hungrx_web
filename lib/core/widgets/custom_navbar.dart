import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum NavbarItem {
  dashboard,
  restaurant,
  commonFood,
  grocery;

  String get label {
    switch (this) {
      case NavbarItem.dashboard:
        return 'DASHBOARD';
      case NavbarItem.restaurant:
        return 'RESTAURANT';
      case NavbarItem.commonFood:
        return 'COMMON FOOD';
      case NavbarItem.grocery:
        return 'GROCERY';
    }
  }

  IconData get icon {
    switch (this) {
      case NavbarItem.dashboard:
        return Icons.dashboard;
      case NavbarItem.restaurant:
        return Icons.restaurant;
      case NavbarItem.commonFood:
        return Icons.fastfood;
      case NavbarItem.grocery:
        return Icons.shopping_basket;
    }
  }

  String get routeName {
    switch (this) {
      case NavbarItem.dashboard:
        return 'dashboard';
      case NavbarItem.restaurant:
        return 'restaurant';
      case NavbarItem.commonFood:
        return 'commonFood';
      case NavbarItem.grocery:
        return 'grocery';
    }
  }
}

class CustomNavbar extends StatelessWidget {
  final NavbarItem currentItem;

  const CustomNavbar({
    super.key,
    required this.currentItem,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1200;
        final isTablet = constraints.maxWidth >= 768 && constraints.maxWidth < 1200;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 16 : 24,
            vertical: isTablet ? 12 : 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          child: isDesktop
              ? _buildDesktopNavbar(context)
              : _buildTabletNavbar(context),
        );
      },
    );
  }

  Widget _buildDesktopNavbar(BuildContext context) {
    return Row(
      children: [
        _buildLogo(false),
        const SizedBox(width: 48),
        Expanded(
          child: Row(
            children: [
              for (final item in NavbarItem.values)
                _buildNavItem(
                  context,
                  item.label,
                  currentItem == item,
                  () => _handleNavigation(context, item),
                  showIcon: false,
                ),
            ],
          ),
        ),
        _buildProfileSection(context),
      ],
    );
  }

  Widget _buildTabletNavbar(BuildContext context) {
    return Row(
      children: [
        _buildLogo(true),
        const SizedBox(width: 24),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final item in NavbarItem.values)
                  _buildNavItem(
                    context,
                    item.label,
                    currentItem == item,
                    () => _handleNavigation(context, item),
                    showIcon: true,
                  ),
              ],
            ),
          ),
        ),
        _buildProfileSection(context),
      ],
    );
  }

  Widget _buildLogo(bool isCompact) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: isCompact ? 32 : 40,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.restaurant,
              size: isCompact ? 32 : 40,
            );
          },
        ),
        if (!isCompact) ...[
          const SizedBox(width: 16),
          const Text(
            'hungrX',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    String title,
    bool isActive,
    VoidCallback onTap, {
    required bool showIcon,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: showIcon ? 8 : 16),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: showIcon ? 12 : 16,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isActive ? Colors.green : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showIcon) ...[
                  Icon(
                    NavbarItem.values
                        .firstWhere((item) => item.label == title)
                        .icon,
                    color: isActive ? Colors.green : Colors.grey[700],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  title,
                  style: TextStyle(
                    color: isActive ? Colors.green : Colors.grey[700],
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    fontSize: showIcon ? 14 : 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return PopupMenuButton(
      offset: const Offset(0, 40),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.green.shade100,
        child: const Icon(Icons.person, color: Colors.green),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person_outline),
              SizedBox(width: 8),
              Text('Profile'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings),
              SizedBox(width: 8),
              Text('Settings'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 8),
              Text('Log Out', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 'logout') {
          _handleLogout(context);
        }
      },
    );
  }

  void _handleNavigation(BuildContext context, NavbarItem item) {
    if (item != currentItem) {
      context.pushNamed(item.routeName);
    }
  }

  void _handleLogout(BuildContext context) {
    // Add any logout logic here
    context.pushNamed('login');
  }
}