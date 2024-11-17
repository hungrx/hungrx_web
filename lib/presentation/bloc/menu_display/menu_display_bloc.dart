import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/core/error/menu_exception.dart';
import 'package:hungrx_web/domain/usecase/manu_usecase/get_menu_usecase.dart';
import 'package:hungrx_web/presentation/bloc/menu_display/menu_display_event.dart';
import 'package:hungrx_web/presentation/bloc/menu_display/menu_display_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final GetMenuUseCase _getMenuUseCase;

  MenuBloc(this._getMenuUseCase) : super(MenuInitial()) {
    on<FetchMenu>(_onFetchMenu);
  }

  Future<void> _onFetchMenu(FetchMenu event, Emitter<MenuState> emit) async {
    emit(MenuLoading());
    try {
      final menu = await _getMenuUseCase.execute(event.restaurantId);
      if (menu.data.menu.isEmpty) {
        emit(MenuEmpty('No menu items found for this restaurant.'));
      } else {
        emit(MenuLoaded(menu));
      }
    } on ApiException catch (e) {
      emit(MenuError(e.toString()));
    } catch (e) {
      emit(MenuError('An unexpected error occurred. Please try again.'));
    }
  }
}