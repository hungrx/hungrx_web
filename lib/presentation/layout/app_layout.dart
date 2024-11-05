// File: lib/presentation/layout/app_layout.dart
import 'package:flutter/material.dart';
import 'package:hungrx_web/core/widgets/custom_navbar.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  final NavbarItem currentItem;

  const AppLayout({
    super.key,
    required this.child,
    required this.currentItem,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomNavbar(currentItem: currentItem),
          Expanded(child: child),
        ],
      ),
    );
  }
}