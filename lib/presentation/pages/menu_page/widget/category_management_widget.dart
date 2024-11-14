import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/data/models/menu_category_subcategory_response.dart';
import 'package:hungrx_web/presentation/bloc/menu_category/menu_category_bloc.dart';
import 'package:hungrx_web/presentation/bloc/menu_category/menu_category_event.dart';
import 'package:hungrx_web/presentation/bloc/menu_category/menu_category_state.dart';
import 'package:hungrx_web/presentation/bloc/menu_catgory_subcategory/menu_category_subcategory_bloc.dart';
import 'package:hungrx_web/presentation/bloc/menu_catgory_subcategory/menu_category_subcategory_event.dart';
import 'package:hungrx_web/presentation/bloc/menu_catgory_subcategory/menu_category_subcategory_state.dart';

class CategoryManagementWidget extends StatefulWidget {
  final bool isTablet;

  const CategoryManagementWidget({
    super.key,
    required this.isTablet,
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
              onPressed: () => showAddSubCategoryDialog(context),
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
                                  CreateMenuCategoryEvent(
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
    // Create controllers that will live for the duration of the dialog
    final controllers = _DialogControllers();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return BlocListener<CategorySubcategoryBloc, CategorySubcategoryState>(
          listener: (context, state) {
            if (state is SubcategoryCreatedSuccess) {
              Navigator.pop(dialogContext);
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
                  duration: const Duration(seconds: 3),
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
            } else if (state is CategorySubcategoryError) {
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
                  duration: const Duration(seconds: 5),
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
          child: BlocBuilder<CategorySubcategoryBloc, CategorySubcategoryState>(
            builder: (context, state) {
              if (state is CategorySubcategoryLoading) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Creating subcategory...',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                );
              }

              if (state is CategorySubcategoryLoaded) {
                final categories = state.categories;

                if (categories.isEmpty) {
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
                        onPressed: () => Navigator.pop(dialogContext),
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  content: Form(
                    key: controllers.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          value: controllers.selectedCategoryId,
                          decoration: InputDecoration(
                            labelText: 'Select Main Category',
                            labelStyle: TextStyle(color: Colors.green.shade600),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.green.shade600),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            prefixIcon: Icon(
                              Icons.restaurant_menu,
                              color: Colors.green.shade600,
                            ),
                            errorStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                          items: categories.map((Category category) {
                            return DropdownMenuItem(
                              value: category.id,
                              child: Text(category.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            controllers.selectedCategoryId = value;
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
                          controller: controllers.subCategoryController,
                          decoration: InputDecoration(
                            labelText: 'Subcategory Name',
                            labelStyle: TextStyle(color: Colors.green.shade600),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.green.shade600),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            prefixIcon: Icon(
                              Icons.subdirectory_arrow_right,
                              color: Colors.green.shade600,
                            ),
                            hintText: 'Enter subcategory name',
                            errorStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          textCapitalization: TextCapitalization.words,
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
                          onFieldSubmitted: (_) {
                            _submitForm(context, dialogContext, controllers);
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
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(
                        'CANCEL',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          _submitForm(context, dialogContext, controllers),
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
                      child: const Text(
                        'ADD SUBCATEGORY',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              }

              return AlertDialog(
                title: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade600),
                    const SizedBox(width: 8),
                    const Text('Error'),
                  ],
                ),
                content: const Text(
                  'Failed to load categories. Please try again later.',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      context
                          .read<CategorySubcategoryBloc>()
                          .add(FetchCategoriesAndSubcategories());
                    },
                    child: const Text('RETRY'),
                  ),
                ],
              );
            },
          ),
        );
      },
    ).whenComplete(() {
      // Dispose controllers when dialog is closed
      // controllers.dispose();
    });
  }

  void _submitForm(
    BuildContext context,
    BuildContext dialogContext,
    _DialogControllers controllers,
  ) {
    FocusScope.of(context).unfocus();

    if (controllers.formKey.currentState?.validate() ?? false) {
      final state = context.read<CategorySubcategoryBloc>().state;
      if (state is CategorySubcategoryLoaded) {
        final selectedCategory = state.categories.firstWhere(
            (category) => category.id == controllers.selectedCategoryId);

        final isSubcategoryExists = selectedCategory.subcategories.any(
            (subcategory) =>
                subcategory.name.toLowerCase() ==
                controllers.subCategoryController.text.trim().toLowerCase());

        if (isSubcategoryExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Subcategory "${controllers.subCategoryController.text}" already exists in ${selectedCategory.name}',
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.orange.shade600,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }
      }

      context.read<CategorySubcategoryBloc>().add(
            AddSubcategory(
              categoryId: controllers.selectedCategoryId!,
              subcategoryName: controllers.subCategoryController.text.trim(),
            ),
          );
    }
  }
}

class _DialogControllers {
  final formKey = GlobalKey<FormState>();
  final subCategoryController = TextEditingController();
  String? selectedCategoryId;

  // void dispose() {
  //   subCategoryController.dispose();
  // }
}
