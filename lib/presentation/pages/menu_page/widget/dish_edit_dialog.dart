// File: lib/presentation/pages/restaurant/widgets/dish_edit_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DishEditDialog extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const DishEditDialog({
    super.key,
    this.initialData,
  });

  @override
  State<DishEditDialog> createState() => _DishEditDialogState();
}

class _DishEditDialogState extends State<DishEditDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedMainCategory;
  String? _selectedSubCategory;
  
  // Controllers for text fields
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _caloriesController;
  late final TextEditingController _proteinController;
  late final TextEditingController _carbsController;
  late final TextEditingController _fatController;
  late final TextEditingController _servingSizeController;

  // Category data
  final Map<String, List<String>> categoryMap = {
    'BURRITO': ['CHICKEN', 'BEEF', 'VEGGIE'],
    'BUTTITO BOWL': ['CLASSIC', 'SPECIAL'],
    'LIFESTYLE BOWL': ['KETO', 'PALEO', 'WHOLE30'],
    'QUESADILLA': [],
    'SALAD': ['REGULAR', 'PROTEIN'],
    'TORTILLA': [],
    'INCLUDED TOPPINGS': [],
    'ADD-ONS': [],
  };

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data if available
    _nameController = TextEditingController(text: widget.initialData?['name'] ?? '');
    _priceController = TextEditingController(text: widget.initialData?['price']?.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.initialData?['description'] ?? '');
    _caloriesController = TextEditingController(text: widget.initialData?['calories'] ?? '');
    _proteinController = TextEditingController(text: widget.initialData?['protein'] ?? '');
    _carbsController = TextEditingController(text: widget.initialData?['carbs'] ?? '');
    _fatController = TextEditingController(text: widget.initialData?['fat'] ?? '');
    _servingSizeController = TextEditingController(text: widget.initialData?['servingSize'] ?? '');
    
    _selectedMainCategory = widget.initialData?['mainCategory'];
    _selectedSubCategory = widget.initialData?['subCategory'];
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
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
              _buildSaveButton(),
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
          'DISH DETAILS',
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
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Show image if available, otherwise show placeholder
          Image.asset(
            'assets/images/smoked_brisket.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade100,
                child: const Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 48,
                  color: Colors.grey,
                ),
              );
            },
          ),
          // Overlay button for image upload
          Positioned(
            bottom: 8,
            right: 8,
            child: CircleAvatar(
              backgroundColor: Colors.green.shade600,
              child: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'NAME',
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
        TextFormField(
          controller: _priceController,
          decoration: const InputDecoration(
            labelText: 'PRICE',
            prefixText: '\$ ',
            border: OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'DESCRIPTION',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 24),
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
                  suffixText: 'G',
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
                  labelText: 'PROTEINS',
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
                  labelText: 'FATS',
                  suffixText: 'G',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'CATEGORY',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedMainCategory,
          decoration: const InputDecoration(
            labelText: 'MAIN CATEGORY',
            border: OutlineInputBorder(),
          ),
          items: [
            for (final category in categoryMap.keys)
              DropdownMenuItem(
                value: category,
                child: Text(category),
              ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedMainCategory = value;
              _selectedSubCategory = null;
            });
          },
        ),
        if (_selectedMainCategory != null &&
            categoryMap[_selectedMainCategory]!.isNotEmpty) ...[
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedSubCategory,
            decoration: const InputDecoration(
              labelText: 'SUB CATEGORY',
              border: OutlineInputBorder(),
            ),
            items: [
              for (final subCategory in categoryMap[_selectedMainCategory]!)
                DropdownMenuItem(
                  value: subCategory,
                  child: Text(subCategory),
                ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedSubCategory = value;
              });
            },
          ),
        ],
        const SizedBox(height: 24),
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
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: _saveDish,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text('SAVE'),
      ),
    );
  }

  void _saveDish() {
    if (_formKey.currentState?.validate() ?? false) {
      // Collect form data
      final dishData = {
        'name': _nameController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'description': _descriptionController.text,
        'calories': _caloriesController.text,
        'protein': _proteinController.text,
        'carbs': _carbsController.text,
        'fat': _fatController.text,
        'mainCategory': _selectedMainCategory,
        'subCategory': _selectedSubCategory,
        'servingSize': _servingSizeController.text,
      };
      
      // Return the data to the caller
      Navigator.pop(context, dishData);
    }
  }
}