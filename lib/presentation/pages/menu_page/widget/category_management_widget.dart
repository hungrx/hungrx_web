import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/presentation/bloc/add_menu_main_category/menu_category_bloc.dart';
import 'package:hungrx_web/presentation/bloc/add_menu_main_category/menu_category_event.dart';
import 'package:hungrx_web/presentation/bloc/add_menu_main_category/menu_category_state.dart';
import 'package:hungrx_web/presentation/pages/menu_page/widget/create_subcategory_dialog.dart';

class CategoryManagementWidget extends StatefulWidget {
  final bool isTablet;
  final String restaurantId;

  const CategoryManagementWidget({
    super.key,
    required this.isTablet,
    required this.restaurantId,
  });

  @override
  State<CategoryManagementWidget> createState() =>
      _CategoryManagementWidgetState();
}

class _CategoryManagementWidgetState extends State<CategoryManagementWidget> {
  final _categoryController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  BuildContext? _dialogContext;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MenuCategoryBloc, MenuCategoryState>(
      listener: (context, state) {
        if (state is MenuCategoryCreatedSuccess) {
          if (_dialogContext != null) {
            Navigator.pop(_dialogContext!); // Close only the dialog
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green.shade600,
            ),
          );
        } else if (state is MenuCategoryError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade600,
            ),
          );
        }
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(widget.isTablet ? 12.0 : 16.0),
            child: ElevatedButton.icon(
              onPressed: () => showAddCategoryDialog(context),
              icon: Icon(Icons.add, size: widget.isTablet ? 18 : 24),
              label: Text(
                widget.isTablet ? 'NEW' : 'NEW CATEGORY',
                style: TextStyle(fontSize: widget.isTablet ? 12 : 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: widget.isTablet ? 12 : 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(widget.isTablet ? 12.0 : 16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                showAddSubCategoryDialog(context);
              },
              icon: Icon(Icons.subdirectory_arrow_right,
                  size: widget.isTablet ? 18 : 24),
              label: Text(
                widget.isTablet ? 'SUB' : 'NEW SUBCATEGORY',
                style: TextStyle(fontSize: widget.isTablet ? 12 : 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: widget.isTablet ? 12 : 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        _dialogContext = dialogContext; // Store dialog context
        return BlocBuilder<MenuCategoryBloc, MenuCategoryState>(
          builder: (context, state) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.category, color: Colors.green.shade600),
                  const SizedBox(width: 8),
                  const Text(
                    'Add New Category',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _categoryController,
                      decoration: InputDecoration(
                        labelText: 'Category Name',
                        labelStyle: TextStyle(color: Colors.green.shade600),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.green.shade600),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        prefixIcon: Icon(
                          Icons.restaurant_menu,
                          color: Colors.green.shade600,
                        ),
                        hintText: 'Enter category name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter category name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create a new main category for your menu items',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    _dialogContext = null; // Clear dialog context
                  },
                  child: Text(
                    'CANCEL',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
                ElevatedButton(
                  onPressed: state is MenuCategoryLoading
                      ? null
                      : () {
                          if (_formKey.currentState?.validate() ?? false) {
                            context.read<MenuCategoryBloc>().add(
                                  CreateMenuCategoryEvent(widget.restaurantId,
                                      _categoryController.text),
                                );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: state is MenuCategoryLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'ADD CATEGORY',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
              actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            );
          },
        );
      },
    );
  }

  void showAddSubCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>  DropdownMenuCategoryDialog(
        restaurantId: widget.restaurantId,
      ),
    );
  }
}
