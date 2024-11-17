import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/data/models/menu_models/dish_edit_model.dart';
import 'package:hungrx_web/data/repositories/menu_repo/dish_edit_repository.dart';
import 'package:hungrx_web/presentation/bloc/dish_editing/dish_editing_bloc.dart';
import 'package:hungrx_web/presentation/bloc/dish_editing/dish_editing_event.dart';
import 'package:hungrx_web/presentation/bloc/dish_editing/dish_editing_state.dart';
import 'package:image_picker_web/image_picker_web.dart';

class DishEditDialog extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final String restaurantId;
  final String menuId;
  final String dishId;

  const DishEditDialog({
    super.key,
    this.initialData,
    required this.restaurantId,
    required this.menuId,
    required this.dishId,
  });

  @override
  State<DishEditDialog> createState() => _DishEditDialogState();
}

class _DishEditDialogState extends State<DishEditDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  String? _selectedSubcategory;
  Uint8List? _imageBytes;
  String? _imageName;
  bool _isSubmitting = false;

  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _caloriesController;
  late final TextEditingController _proteinController;
  late final TextEditingController _carbsController;
  late final TextEditingController _fatController;
  late final TextEditingController _servingSizeController;
  late final TextEditingController _ratingController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();

  }

  void _initializeControllers() {
    _nameController =
        TextEditingController(text: widget.initialData?['name'] ?? '');
    _priceController = TextEditingController(
        text: widget.initialData?['price']?.toString() ?? '');
    _descriptionController =
        TextEditingController(text: widget.initialData?['description'] ?? '');
    _caloriesController = TextEditingController(
        text: widget.initialData?['calories']?.toString() ?? '');
    _proteinController = TextEditingController(
        text: widget.initialData?['protein']?.toString() ?? '');
    _carbsController = TextEditingController(
        text: widget.initialData?['carbs']?.toString() ?? '');
    _fatController = TextEditingController(
        text: widget.initialData?['fats']?.toString() ?? '');
    _servingSizeController = TextEditingController(
        text: widget.initialData?['servingSize']?.toString() ?? '');
    _ratingController = TextEditingController(
        text: widget.initialData?['rating']?.toString() ?? '4.2');
    _selectedCategory = widget.initialData?['categoryId'];
    _selectedSubcategory = widget.initialData?['subcategoryId'];
  }



  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _servingSizeController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final MediaInfo? files = await ImagePickerWeb.getImageInfo();
      if (files != null && files.data != null) {
        setState(() {
          _imageBytes = files.data!;
          _imageName = files.fileName ?? 'restaurant_image.jpg';
          // _imageChanged = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error picking image. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

   @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DishEditBloc>(
          create: (context) => DishEditBloc(
            repository: DishEditRepository(),
          ),
        ),

      ],
        child: BlocListener<DishEditBloc, DishEditState>(
        listener: (context, state) {
          if (_isSubmitting) {
            if (state is DishEditSuccess) {
              _isSubmitting = false;
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              // Safely pop the dialog with result
              if (mounted && Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            } else if (state is DishEditFailure) {
              _isSubmitting = false;
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: 800,
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildImageSection(),
                          const SizedBox(width: 24),
                          Expanded(
                            child: _buildFormFields(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
        
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'EDIT DISH',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_imageBytes != null)
                Image.memory(
                  _imageBytes!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                )
              else if (widget.initialData?['image'] != null)
                Image.network(
                  widget.initialData!['image'],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildImagePlaceholder();
                  },
                )
              else
                _buildImagePlaceholder(),
              Positioned(
                bottom: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.green.shade600,
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: _pickImage,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_imageName != null) ...[
          const SizedBox(height: 8),
          Text(
            'Selected: $_imageName',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey.shade100,
      child: const Icon(
        Icons.add_photo_alternate_outlined,
        size: 48,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBasicInfoSection(),
        const SizedBox(height: 24),
        _buildNutritionSection(),
        const SizedBox(height: 24),
      
        const SizedBox(height: 24),
        _buildServingSection(),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'BASIC INFORMATION',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'DISH NAME',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter a name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'PRICE',
            prefixText: '\$ ',
            border: OutlineInputBorder(),
          ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _ratingController,
                decoration: const InputDecoration(
                  labelText: 'RATING (1-5)',
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter rating';
                  }
                  final rating = double.tryParse(value);
                  if (rating == null || rating < 1 || rating > 5) {
                    return 'Rating must be between 1 and 5';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'DESCRIPTION',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildNutritionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'NUTRITION FACTS',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _caloriesController,
                decoration: const InputDecoration(
                  labelText: 'CALORIES',
                  suffixText: 'KCAL',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _carbsController,
                decoration: const InputDecoration(
                  labelText: 'CARBS',
                  suffixText: 'G',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _proteinController,
                decoration: const InputDecoration(
                  labelText: 'PROTEIN',
                  suffixText: 'G',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _fatController,
                decoration: const InputDecoration(
                  labelText: 'FAT',
                  suffixText: 'G',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget _buildCategorySection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         'CATEGORY',
  //         style: TextStyle(
  //           fontSize: 18,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       const SizedBox(height: 16),
  //       BlocBuilder<CategorySubcategoryBloc, CategorySubcategoryState>(
  //         builder: (context, state) {
  //           if (state is CategorySubcategoryLoading) {
  //             return const Center(child: CircularProgressIndicator());
  //           }

  //           if (state is CategorySubcategoryLoaded) {
  //             if (state.categories.isEmpty) {
  //               return const Text('No categories available');
  //             }

  //             // Ensure selected category defaults to the first category if none is selected
  //             final selectedCategoryObj = _selectedCategory != null
  //                 ? state.categories.firstWhere(
  //                     (cat) => cat.id == _selectedCategory,
  //                     orElse: () => state.categories.first,
  //                   )
  //                 : state.categories.first;

  //             return Column(
  //               children: [
  //                 DropdownButtonFormField<String>(
  //                   value: _selectedCategory,
  //                   decoration: InputDecoration(
  //                     labelText: 'MAIN CATEGORY',
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(8),
  //                     ),
  //                   ),
  //                   items: state.categories.map((category) {
  //                     return DropdownMenuItem(
  //                       value: category.id,
  //                       child: Text(category.name),
  //                     );
  //                   }).toList(),
  //                   onChanged: (value) {
  //                     setState(() {
  //                       _selectedCategory = value;
  //                       _selectedSubcategory = null; // Reset subcategory
  //                     });
  //                   },
  //                   validator: (value) => value == null || value.isEmpty
  //                       ? 'Please select a category'
  //                       : null,
  //                 ),
  //                 if (_selectedCategory != null) ...[
  //                   const SizedBox(height: 16),
  //                   DropdownButtonFormField<String>(
  //                     value: _selectedSubcategory,
  //                     decoration: InputDecoration(
  //                       labelText: 'SUB CATEGORY',
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(8),
  //                       ),
  //                     ),
  //                     items:
  //                         selectedCategoryObj.subcategories.map((subcategory) {
  //                       return DropdownMenuItem(
  //                         value: subcategory.id,
  //                         child: Text(subcategory.name),
  //                       );
  //                     }).toList(),
  //                     onChanged: (value) {
  //                       setState(() {
  //                         _selectedSubcategory = value;
  //                       });
  //                     },
  //                     validator: (value) => value == null || value.isEmpty
  //                         ? 'Please select a subcategory'
  //                         : null,
  //                   ),
  //                 ],
  //               ],
  //             );
  //           }

  //           if (state is CategorySubcategoryError) {
  //             return ErrorDisplay(
  //               message: state.message,
  //               onRetry: () => context.read<CategorySubcategoryBloc>().add(
  //                     FetchCategoriesAndSubcategories(),
  //                   ),
  //             );
  //           }

  //           return const Text('Failed to load categories');
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget _buildServingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SERVING SIZE',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _servingSizeController,
          decoration: const InputDecoration(
            labelText: 'SIZE',
            suffixText: 'G',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter serving size';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return BlocBuilder<DishEditBloc, DishEditState>(
      builder: (context, state) {
        final isLoading = state is DishEditLoading || _isSubmitting;
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: isLoading
                  ? null
                  : () {
                   if (mounted && Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                  },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('CANCEL'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: isLoading
                  ? null 
                  : () => _saveDish(context), // Modified to pass context
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'SAVE CHANGES',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  void _saveDish(BuildContext context) {
    if (_isSubmitting) return;
    if (_formKey.currentState?.validate() ?? false) {
           setState(() {
        _isSubmitting = true;
      });
      
      try {
        final dish = DishEditModel(
          name: _nameController.text,
          price: double.parse(_priceController.text),
          rating: double.parse(_ratingController.text),
          description: _descriptionController.text,
          calories: _caloriesController.text,
          carbs: _carbsController.text,
          protein: _proteinController.text,
          fats: _fatController.text,
          servingSize: _servingSizeController.text,
          servingUnit: 'g',
          categoryId: _selectedCategory ?? '',
          subcategoryId: _selectedSubcategory ?? '',
          restaurantId: widget.restaurantId,
          menuId: widget.menuId,
          dishId: widget.dishId,
        );
         if (!mounted) return;

        // Get the bloc instance
        final dishEditBloc = context.read<DishEditBloc>();

        dishEditBloc.add(
          DishEditSubmitted(
            dish: dish,
            imageBytes: _imageBytes,
            imageName: _imageName,
          ),
        );
      } catch (e) {
        setState(() {
          _isSubmitting = false;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving dish: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
    }
  }
}
