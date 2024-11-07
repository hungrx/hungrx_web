import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final String searchHint;
  final String buttonLabel;
  final VoidCallback onAddPressed;
  final ValueChanged<String>? onSearchChanged;
  final bool isTablet;

  const CustomHeader({
    super.key,
    required this.title,
    required this.onAddPressed,
    this.searchHint = 'Search...',
    this.buttonLabel = 'ADD',
    this.onSearchChanged,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - Header Text
          Text(
            title,
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
                      controller: searchController,
                      onChanged: onSearchChanged,
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          // Navigate to search results page
                          context.pushNamed(
                            'search',
                            queryParameters: {'q': value.trim()},
                          );
                        }
                      },
                      decoration: InputDecoration(
                        hintText: searchHint,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            if (onSearchChanged != null) {
                              onSearchChanged!('');
                            }
                          },
                        ),
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
                  onPressed: onAddPressed,
                  icon: const Icon(Icons.add),
                  label: Text(
                    isTablet ? 'ADD' : buttonLabel,
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
}