import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/data/models/menu_models/add_food_category_request.dart';
import 'package:hungrx_web/data/repositories/menu_repo/add_food_category_repository.dart';
import 'package:hungrx_web/presentation/bloc/add_food_to_category/add_food_to_category_event.dart';
import 'package:hungrx_web/presentation/bloc/add_food_to_category/add_food_to_category_state.dart';

class AddFoodCategoryBloc extends Bloc<AddFoodCategoryEvent, AddFoodCategoryState> {
  final AddFoodCategoryRepository repository;

  AddFoodCategoryBloc({required this.repository}) : super(AddFoodCategoryInitial()) {
    on<AddFoodToCategoryEvent>(_onAddFoodToCategory);
  }

  Future<void> _onAddFoodToCategory(
    AddFoodToCategoryEvent event,
    Emitter<AddFoodCategoryState> emit,
  ) async {
    try {
      // Start loading
      emit(AddFoodCategoryLoading());

      // Validate request data
      if (event.restaurantId.isEmpty ||
          event.menuId.isEmpty ||
          event.categoryId.isEmpty ||
          event.dishId.isEmpty) {
        emit(AddFoodCategoryError('Missing required information'));
        return;
      }

      final request = AddFoodCategoryRequest(
        restaurantId: event.restaurantId,
        menuId: event.menuId,
        categoryId: event.categoryId,
        dishId: event.dishId,
        subcategoryId: event.subcategoryId,
      );

      final response = await repository.addFoodToCategory(request);
      
      if (response.status) {
        emit(AddFoodCategorySuccess(response.message));
      } else {
        emit(AddFoodCategoryError(response.message));
      }
    } catch (e) {
      emit(AddFoodCategoryError('Failed to add food to category: ${e.toString()}'));
    }
  }
}