import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/data/models/menu_models/quick_search_response.dart';
import 'package:hungrx_web/presentation/bloc/add_food_to_category/add_food_to_category_bloc.dart';
import 'package:hungrx_web/presentation/bloc/add_food_to_category/add_food_to_category_event.dart';
import 'package:hungrx_web/presentation/bloc/add_food_to_category/add_food_to_category_state.dart';

class AddButtonState {
  final bool isAdded;
  final bool isLoading;

  AddButtonState({
    this.isAdded = false,
    this.isLoading = false,
  });

  AddButtonState copyWith({
    bool? isAdded,
    bool? isLoading,
  }) {
    return AddButtonState(
      isAdded: isAdded ?? this.isAdded,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class DishAddButton extends StatefulWidget {
  final int index;
  final String restaurantId;
  final String menuId;
  final String categoryId;
  final String? subcategoryId;
  final DishItem dish;
  final Function() onDishAdded;

  const DishAddButton({
    required this.index,
    super.key,
    required this.restaurantId,
    required this.menuId,
    required this.categoryId,
    this.subcategoryId,
    required this.dish,
    required this.onDishAdded,
  });

  @override
  State<DishAddButton> createState() => _DishAddButtonState();
}

class _DishAddButtonState extends State<DishAddButton> {
  AddButtonState _buttonState = AddButtonState();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddFoodCategoryBloc, AddFoodCategoryState>(
      listener: (context, state) {
        if (state is AddFoodCategorySuccess) {
          setState(() {
            _buttonState = AddButtonState(isAdded: true, isLoading: false);
          });
           widget.onDishAdded();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is AddFoodCategoryError) {
          setState(() {
            _buttonState = AddButtonState(isAdded: false, isLoading: false);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: IconButton(
        icon: _buildIcon(),
        color: _getIconColor(),
        iconSize: 32,
        onPressed: _buttonState.isLoading || _buttonState.isAdded 
            ? null 
            : () => _addDishToCategory(context),
      ),
    );
  }

  Widget _buildIcon() {
    if (_buttonState.isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    } else if (_buttonState.isAdded) {
      return const Icon(Icons.check_circle);
    } else {
      return const Icon(Icons.add_circle_outline);
    }
  }

  Color _getIconColor() {
    if (_buttonState.isAdded) {
      return Colors.green;
    } else {
      return Theme.of(context).primaryColor;
    }
  }

  void _addDishToCategory(BuildContext context) {
    if (widget.restaurantId.isEmpty ||
        widget.menuId.isEmpty ||
        widget.categoryId.isEmpty ||
        widget.dish.id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Missing required information'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _buttonState = _buttonState.copyWith(isLoading: true);
    });

    try {
      context.read<AddFoodCategoryBloc>().add(
            AddFoodToCategoryEvent(
              restaurantId: widget.restaurantId,
              menuId: widget.menuId,
              categoryId: widget.categoryId,
              dishId: widget.dish.id,
              subcategoryId: widget.subcategoryId,
            ),
          );
    } catch (e) {
      setState(() {
        _buttonState = AddButtonState();
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}