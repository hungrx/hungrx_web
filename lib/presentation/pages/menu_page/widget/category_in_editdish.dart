// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hungrx_web/data/models/menu_category_subcategory_response.dart';



// class CategorySection extends StatefulWidget {
//   const CategorySection({super.key});

//   @override
//   State<CategorySection> createState() => _CategorySectionState();
// }

// class _CategorySectionState extends State<CategorySection> {
//   String? _selectedCategory;
//   String? _selectedSubcategory;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'CATEGORY',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 16),
//         BlocConsumer<CategorySubcategoryBloc, CategorySubcategoryState>(
//           listener: (context, state) {
//             if (state is SubcategoryCreatedSuccess) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text(state.message)),
//               );
//             }
//           },
//           builder: (context, state) {
//             if (state is CategorySubcategoryLoading) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }

//             if (state is CategorySubcategoryError) {
//               return ErrorDisplay(
//                 message: state.message,
//                 onRetry: () => context.read<CategorySubcategoryBloc>().add(
//                       FetchCategoriesAndSubcategories(),
//                     ),
//               );
//             }

//             if (state is CategorySubcategoryLoaded) {
//               return _buildCategoryDropdowns(state.categories);
//             }

//             return const SizedBox.shrink();
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildCategoryDropdowns(List<Category> categories) {
//     if (categories.isEmpty) {
//       return const Text('No categories available');
//     }

//     // Find selected category safely
//     Category selectedCategoryObj = _selectedCategory != null
//         ? categories.firstWhere(
//             (cat) => cat.id == _selectedCategory,
//             orElse: () => Category(
//               id: '',
//               name: '',
//               subcategories: [],
//               totalSubcategories: 0,
//               createdAt: DateTime.now(),
//               updatedAt: DateTime.now(),
//             ),
//           )
//         : categories.first; // Use first category as default

//     return Column(
//       children: [
//         // Main Category Dropdown
//         DropdownButtonFormField<String>(
//           value: _selectedCategory,
//           decoration: InputDecoration(
//             labelText: 'MAIN CATEGORY',
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           items: categories.map((category) {
//             return DropdownMenuItem(
//               value: category.id,
//               child: Text(category.name),
//             );
//           }).toList(),
//           onChanged: (value) {
//             setState(() {
//               _selectedCategory = value;
//               _selectedSubcategory = null;
//             });
//           },
//           validator: (value) =>
//               value == null || value.isEmpty ? 'Please select a category' : null,
//         ),
        
//         // Only show subcategory dropdown if category is selected and valid
//         if (_selectedCategory != null && selectedCategoryObj.id.isNotEmpty) ...[
//           const SizedBox(height: 16),
//           DropdownButtonFormField<String>(
//             value: _selectedSubcategory,
//             decoration: InputDecoration(
//               labelText: 'SUB CATEGORY',
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             items: selectedCategoryObj.subcategories.map((subcategory) {
//               return DropdownMenuItem(
//                 value: subcategory.id,
//                 child: Text(subcategory.name),
//               );
//             }).toList(),
//             onChanged: (value) {
//               setState(() {
//                 _selectedSubcategory = value;
//               });
//             },
//             validator: (value) =>
//                 value == null || value.isEmpty ? 'Please select a subcategory' : null,
//           ),
//         ],
//       ],
//     );
//   }
// }

// class ErrorDisplay extends StatelessWidget {
//   final String message;
//   final VoidCallback onRetry;

//   const ErrorDisplay({
//     super.key,
//     required this.message,
//     required this.onRetry,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(
//           'Error: $message',
//           style: const TextStyle(color: Colors.red),
//         ),
//         const SizedBox(height: 8),
//         ElevatedButton(
//           onPressed: onRetry,
//           child: const Text('Retry'),
//         ),
//       ],
//     );
//   }
// }