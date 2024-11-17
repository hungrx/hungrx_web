import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/data/models/menu_models/add_menu_subcategory_model.dart';
import 'package:hungrx_web/domain/usecase/manu_usecase/create_menu_subcategory.dart';
import 'package:hungrx_web/presentation/bloc/add_menu_subcategory/add_menu_subcategory_event.dart';
import 'package:hungrx_web/presentation/bloc/add_menu_subcategory/add_menu_subcategory_state.dart';

class AddMenuSubcategoryBloc
    extends Bloc<AddMenuSubcategoryEvent, AddMenuSubcategoryState> {
  final CreateMenuSubcategory createMenuSubcategory;

  AddMenuSubcategoryBloc({required this.createMenuSubcategory})
      : super(AddMenuSubcategoryInitial()) {
    on<CreateAddMenuSubcategory>(_onCreateAddMenuSubcategory);
  }

  Future<void> _onCreateAddMenuSubcategory(
    CreateAddMenuSubcategory event,
    Emitter<AddMenuSubcategoryState> emit,
  ) async {
    emit(AddMenuSubcategoryLoading());
    try {
      final request = AddMenuSubcategoryRequest(
        restaurantId: event.restaurantId,
        name: event.name,
        categoryId: event.categoryId,
      );
      final response = await createMenuSubcategory.execute(request);
      emit(AddMenuSubcategorySuccess(
        message: response.message,
        subcategory: response.subcategory,
      ));
    } catch (e) {
      emit(AddMenuSubcategoryError(message: e.toString()));
    }
  }
}