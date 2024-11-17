import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/data/repositories/restaurant_repo/add_category_repository.dart';
import 'package:hungrx_web/presentation/bloc/restuarant_category/add_catogory/add_category_event.dart';
import 'package:hungrx_web/presentation/bloc/restuarant_category/add_catogory/add_category_state.dart';

class AddCategoryBloc extends Bloc<AddCategoryEvent, AddCategoryState> {
  final AddCategoryRepository repository;

  AddCategoryBloc({required this.repository}) : super(AddCategoryInitial()) {
    on<AddNewCategory>(_onAddNewCategory);
  }

  Future<void> _onAddNewCategory(
    AddNewCategory event,
    Emitter<AddCategoryState> emit,
  ) async {
    emit(AddCategoryLoading());

    final result = await repository.addCategory(event.name);

    result.fold(
      (failure) => emit(AddCategoryFailure(failure.message)),
      (response) {
        if (response.status) {
          emit(AddCategorySuccess('Category added successfully'));
        } else {
          emit(AddCategoryFailure(response.message));
        }
      },
    );
  }
}