  import 'dart:typed_data';
  import 'package:flutter/material.dart';
  import 'package:image_picker_web/image_picker_web.dart';

  class AddRestaurantDialog extends StatefulWidget {
    final List<String> categories;

    const AddRestaurantDialog({
      super.key,
      required this.categories,
    });

    @override
    State<AddRestaurantDialog> createState() => _AddRestaurantDialogState();
  }

  class _AddRestaurantDialogState extends State<AddRestaurantDialog> {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _ratingController = TextEditingController();
    final _descriptionController = TextEditingController();
    String? _selectedCategory;
    Uint8List? _imageBytes;
    String? _imageName;
    bool _isLoading = false;

    @override
    void dispose() {
      _nameController.dispose();
      _ratingController.dispose();
      _descriptionController.dispose();
      super.dispose();
    }

    Future<void> _pickImage() async {
      try {
        final files = await ImagePickerWeb.getImageInfo;
        if (files != null) {
          // setState(() {
          //   _imageBytes = files.data;
          //   _imageName = files.fileName;
          // });
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
        if (_imageBytes == null) {
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
          // Create restaurant data
          // final restaurantData = {
          //   'name': _nameController.text,
          //   'category': _selectedCategory,
          //   'rating': double.parse(_ratingController.text),
          //   'description': _descriptionController.text,
          //   'image': _imageBytes,
          //   'imageName': _imageName,
          // };

          // Add restaurant using BLoC
          // context.read<RestaurantBloc>().add(
          //       // AddRestaurant(restaurantData: restaurantData),
          //     );

          Navigator.of(context).pop();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error adding restaurant: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        } finally {
          setState(() => _isLoading = false);
        }
      }
    }

    @override
    Widget build(BuildContext context) {
      final screenSize = MediaQuery.of(context).size;
      final dialogWidth = screenSize.width * 0.8;
      final dialogHeight = screenSize.height * 0.8;

      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: dialogWidth,
          height: dialogHeight,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'RESTAURANT DETAILS',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Section
                    Expanded(
                      flex: 1,
                      child: _buildImageSection(),
                    ),
                    const SizedBox(width: 24),
                    // Form Section
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
      );
    }

    Widget _buildImageSection() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: _imageBytes != null
            ? Stack(
                children: [
                  Image.memory(
                    _imageBytes!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() {
                        _imageBytes = null;
                        _imageName = null;
                      }),
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
                      onPressed: _pickImage,
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
      return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
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
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'CATEGORY TYPE',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: widget.categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
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
                decoration: InputDecoration(
                  labelText: 'RATING (4.5 - 5)',
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
                  if (rating == null || rating < 4.5 || rating > 5) {
                    return 'Rating must be between 4.5 and 5';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
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
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'SAVE',
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