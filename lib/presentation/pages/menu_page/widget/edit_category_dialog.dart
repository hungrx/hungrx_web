import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/data/datasource/api/menu_api/edit_menu_category_api_service.dart';
import 'package:hungrx_web/data/repositories/menu_repo/edit_category_repository.dart';
import 'package:hungrx_web/domain/usecase/manu_usecase/edit_category_usecase.dart';
import 'package:hungrx_web/presentation/bloc/edit_menu_category/edit_menu_category_bloc.dart';
import 'package:hungrx_web/presentation/bloc/edit_menu_category/edit_menu_category_event.dart';
import 'package:hungrx_web/presentation/bloc/edit_menu_category/edit_menu_category_state.dart';

class EditCategoryDialog extends StatefulWidget {
  final String categoryId;
  final String restaurantId;
  final String currentName;

  const EditCategoryDialog({
    super.key,
    required this.categoryId,
    required this.restaurantId,
    required this.currentName,
  });

  @override
  State<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditCategoryBloc(
        EditCategoryUseCase(
          CategoryRepository(
            CategoryApiService(),
          ),
        ),
      ),
      child: BlocListener<EditCategoryBloc, EditCategoryState>(
        listener: (context, state) {
          if (state is EditCategorySuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pop(context, true);
          } else if (state is EditCategoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: AlertDialog(
          title: const Text('Edit Category'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Category Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            BlocBuilder<EditCategoryBloc, EditCategoryState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state is EditCategoryLoading
                      ? null
                      : () {
                          context.read<EditCategoryBloc>().add(
                                EditCategorySubmitted(
                                  categoryId: widget.categoryId,
                                  restaurantId: widget.restaurantId,
                                  name: _nameController.text.trim(),
                                ),
                              );
                        },
                  child: state is EditCategoryLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
