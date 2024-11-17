import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/presentation/bloc/dropdown_menu_category/dropdown_menu_category_bloc.dart';
import 'package:hungrx_web/presentation/bloc/dropdown_menu_category/dropdown_menu_category_event.dart';
import 'package:hungrx_web/presentation/bloc/dropdown_menu_category/dropdown_menu_category_state.dart';
import 'package:hungrx_web/presentation/bloc/add_menu_subcategory/add_menu_subcategory_bloc.dart';
import 'package:hungrx_web/presentation/bloc/add_menu_subcategory/add_menu_subcategory_event.dart';
import 'package:hungrx_web/presentation/bloc/add_menu_subcategory/add_menu_subcategory_state.dart';

class DropdownMenuCategoryDialog extends StatefulWidget {
  final String restaurantId;

  const DropdownMenuCategoryDialog({
    super.key,
    required this.restaurantId,
  });

  @override
  State<DropdownMenuCategoryDialog> createState() => _DropdownMenuCategoryDialogState();
}

class _DropdownMenuCategoryDialogState extends State<DropdownMenuCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _subCategoryController = TextEditingController();
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    context.read<DropdownMenuCategoryBloc>().add(
          FetchDropdownMenuCategories(restaurantId: widget.restaurantId),
        );
  }

  @override
  void dispose() {
    _subCategoryController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AddMenuSubcategoryBloc>().add(
            CreateAddMenuSubcategory(
              restaurantId: widget.restaurantId,
              name: _subCategoryController.text,
              categoryId: _selectedCategoryId!,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddMenuSubcategoryBloc, AddMenuSubcategoryState>(
          listener: (context, state) {
            if (state is AddMenuSubcategorySuccess) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(child: Text(state.message)),
                    ],
                  ),
                  backgroundColor: Colors.green.shade600,
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: 'DISMISS',
                    textColor: Colors.white,
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                ),
              );
            } else if (state is AddMenuSubcategoryError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(child: Text(state.message)),
                    ],
                  ),
                  backgroundColor: Colors.red.shade600,
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: 'DISMISS',
                    textColor: Colors.white,
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                ),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<DropdownMenuCategoryBloc, DropdownMenuCategoryState>(
        builder: (context, state) {
          if (state is DropdownMenuCategoryLoading) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Loading categories...',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          if (state is DropdownMenuCategoryError) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade600),
                  const SizedBox(width: 8),
                  const Text('Error'),
                ],
              ),
              content: Text(state.message),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<DropdownMenuCategoryBloc>().add(
                          FetchDropdownMenuCategories(
                            restaurantId: widget.restaurantId,
                          ),
                        );
                  },
                  child: const Text('RETRY'),
                ),
              ],
            );
          }

          if (state is DropdownMenuCategoryLoaded) {
            if (state.categories.isEmpty) {
              return AlertDialog(
                title: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange.shade600),
                    const SizedBox(width: 8),
                    const Text('No Categories Available'),
                  ],
                ),
                content: const Text(
                  'Please create a main category first before adding subcategories.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              );
            }

            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.category, color: Colors.green.shade600),
                  const SizedBox(width: 8),
                  const Text(
                    'Add New Subcategory',
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
                    DropdownButtonFormField<String>(
                      value: _selectedCategoryId,
                      decoration: InputDecoration(
                        labelText: 'Select Main Category',
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
                      ),
                      items: state.categories.map((category) {
                        return DropdownMenuItem(
                          value: category.id,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoryId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a main category';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _subCategoryController,
                      decoration: InputDecoration(
                        labelText: 'Subcategory Name',
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
                          Icons.subdirectory_arrow_right,
                          color: Colors.green.shade600,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter subcategory name';
                        }
                        if (value.length < 2) {
                          return 'Subcategory name must be at least 2 characters';
                        }
                        if (value.length > 50) {
                          return 'Subcategory name must be less than 50 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create a new subcategory under the selected main category',
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
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'CANCEL',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
                BlocBuilder<AddMenuSubcategoryBloc, AddMenuSubcategoryState>(
                  builder: (context, addState) {
                    return ElevatedButton(
                      onPressed: addState is AddMenuSubcategoryLoading
                          ? null
                          : _handleSubmit,
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
                      child: addState is AddMenuSubcategoryLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'ADD SUBCATEGORY',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    );
                  },
                ),
              ],
            );
          }

          return const AlertDialog(
            content: Text('Something went wrong'),
          );
        },
      ),
    );
  }
}