import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/data/models/restaurant_models/category_model.dart';
import 'package:hungrx_web/data/models/restaurant_models/edit_restaurant_model.dart';
import 'package:hungrx_web/presentation/bloc/edit_restaurant/edit_restaurant_bloc.dart';
import 'package:hungrx_web/presentation/bloc/edit_restaurant/edit_restaurant_event.dart';
import 'package:hungrx_web/presentation/bloc/edit_restaurant/edit_restaurant_state.dart';
import 'package:hungrx_web/presentation/pages/restaurant_page/widget/restuarant_image_widget.dart';
import 'package:image_picker_web/image_picker_web.dart';

class EditRestaurantDialog extends StatefulWidget {
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
  const EditRestaurantDialog({
    super.key,
    required this.name,
    required this.logo,
    required this.descrioption,
    required this.rating,
    required this.id,
    required this.category,
    required this.updatedAt,
    required this.createdAt,
    required this.categories,
    required this.onUpdateSuccess,
  });

  @override
  State<EditRestaurantDialog> createState() => _EditRestaurantDialogState();
}

class _EditRestaurantDialogState extends State<EditRestaurantDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ratingController;
  late TextEditingController _descriptionController;
  String? _selectedCategoryId;
  Uint8List? _imageBytes;
  String? _imageName;
  String? _existingImageUrl;
  bool _isLoading = false;
  bool _imageChanged = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _ratingController = TextEditingController(text: widget.rating);
    _descriptionController = TextEditingController(text: widget.descrioption);
    _existingImageUrl = widget.logo;
    _selectedCategoryId =
        widget.category;

    if (_selectedCategoryId != null &&
        !widget.categories.any((cat) => cat.id == _selectedCategoryId)) {
      _selectedCategoryId = null; 
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ratingController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final MediaInfo? files = await ImagePickerWeb.getImageInfo();
      if (files != null && files.data != null) {
        setState(() {
          _imageBytes = files.data!;
          _imageName = files.fileName ?? 'restaurant_image.jpg';
          _imageChanged = true;
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

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_existingImageUrl == null && _imageBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a restaurant image'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        final restaurant = EditRestaurantModel(
          id: widget.id,
          name: _nameController.text,
          categoryId: _selectedCategoryId ?? '',
          rating: double.parse(_ratingController.text),
          description: _descriptionController.text,
          logoUrl: _existingImageUrl,
          logoBytes: _imageChanged ? _imageBytes : null,
          logoName: _imageChanged ? _imageName : null,
        );

        context.read<EditRestaurantBloc>().add(
              EditRestaurantSubmitEvent(
                restaurantId: widget.id,
                restaurant: restaurant,
              ),
            );
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = screenSize.width * 0.8;
    final dialogHeight = screenSize.height * 0.8;

    return BlocListener<EditRestaurantBloc, EditRestaurantState>(
      listener: (context, state) {
        if (state is EditRestaurantSuccessState) {
          widget.onUpdateSuccess(); // Call the callback on success
          Navigator.of(context).pop(); 
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Restaurant updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is EditRestaurantErrorState) {
          print(state.message);
          setState(() => _isLoading = false); 
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: dialogWidth,
          height: dialogHeight,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: _buildImageSection(),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 1,
                      child: _buildFormSection(),
                    ),
                  ],
                ),
              ),
            ],
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
          'EDIT RESTAURANT',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: _imageBytes != null || _existingImageUrl != null
          ? Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _imageBytes != null
                      ? Image.memory(
                          _imageBytes!,
                          fit: BoxFit.cover,
                        )
                      : RestaurantImageWidget(
                          height: MediaQuery.of(context).size.width * .2,
                          imageUrl: _existingImageUrl!,
                          width: MediaQuery.of(context).size.width * .25,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: _isLoading ? null : _pickImage,
                    color: Colors.white,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black54,
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 48,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _pickImage,
                    icon: const Icon(Icons.upload),
                    label: const Text('Upload Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildFormSection() {
    // Create dropdown items from widget.categories
    List<DropdownMenuItem<String>> categoryItems =
        widget.categories.map((category) {
      return DropdownMenuItem<String>(
        value: category.id,
        child: Text(category.name ??''),
      );
    }).toList();

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: 'NAME',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter restaurant name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategoryId,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'CATEGORY',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: categoryItems,
              onChanged: _isLoading
                  ? null
                  : (value) {
                      setState(() {
                        _selectedCategoryId = value;
                      });
                    },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a category';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ratingController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: 'RATING (1 - 5)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
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
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: 'DESCRIPTION',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
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
                        'UPDATE',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
