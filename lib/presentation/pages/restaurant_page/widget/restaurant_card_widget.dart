import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hungrx_web/data/models/restaurant_models/category_model.dart';
import 'package:hungrx_web/presentation/bloc/edit_restaurant/edit_restaurant_bloc.dart';
import 'package:hungrx_web/presentation/pages/restaurant_page/widget/edit_restuarant_widget.dart';
import 'package:hungrx_web/presentation/pages/restaurant_page/widget/restuarant_image_widget.dart';

class RestaurantCard extends HookWidget {
  final List<CategoryModel> categories;
  final String name;
  final String logo;
  final String descrioption;
  final String rating;
  final String id;
  final String category;
  final String updatedAt;
  final String createdAt;
  final Function() onUpdateSuccess;

  const RestaurantCard({
    super.key,
    required this.categories,
    required this.descrioption,
    required this.rating,
    required this.id,
    required this.category,
    required this.updatedAt,
    required this.createdAt,
    required this.name,
    required this.logo,
    required this.onUpdateSuccess,
  });

  String _sanitizeImageUrl(String url) {
    if (url.startsWith('http://')) {
      url = 'https://${url.substring(7)}';
    }
    return url.contains('digitaloceanspaces.com') ? Uri.encodeFull(url) : url;
  }

  void _navigateToMenuScreen(BuildContext context) {
    final encodedName = Uri.encodeComponent(name);
   context.push('/restaurant-menu/$id/$encodedName');
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: context.read<EditRestaurantBloc>(),
        child: EditRestaurantDialog(
          onUpdateSuccess: onUpdateSuccess,
          categories: categories,
          updatedAt: updatedAt,
          category: category,
          createdAt: createdAt,
          descrioption: descrioption,
          id: id,
          rating: rating,
          name: name,
          logo: logo,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);
    final sanitizedImageUrl = _sanitizeImageUrl(logo);

    return Material(
      color: Colors.transparent,
      child: MouseRegion(
        onEnter: (_) => isHovered.value = true,
        onExit: (_) => isHovered.value = false,
        child: InkWell(
          onTap: () => _navigateToMenuScreen(context),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.identity()..scale(isHovered.value ? 1.02 : 1.0),
            child: Container(

              decoration: BoxDecoration(
              
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black.withOpacity(isHovered.value ? 0.1 : 0.05),
                    spreadRadius: 0,
                    blurRadius: isHovered.value ? 8 : 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Image section with navigation
                        Material(
                         
                          child: ShaderMask(
                            
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.1),
                                ],
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.darken,
                            child: Hero(
                              tag: 'restaurant_image_$id',
                              child: RestaurantImageWidget(
                                height: MediaQuery.of(context).size.width * .2,
                                imageUrl: sanitizedImageUrl,
                                width: MediaQuery.of(context).size.width * .25,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        // Edit button
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 200),
                          top: 8,
                          right: isHovered.value ? 8 : -50,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: isHovered.value ? 1.0 : 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.green.shade600,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Tooltip(
                                message: 'Edit Restaurant',
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () => _showEditDialog(context),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.edit,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Restaurant info section
                  InkWell(
                    onTap: () => _navigateToMenuScreen(context),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      margin: const EdgeInsets.only(right: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade700,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Text(
                                      'OPEN',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'LAST UPDATE: $updatedAt',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    letterSpacing: 0.3,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
