import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/domain/usecase/manu_usecase/get_dishes_by_category_usecase.dart';
import 'package:hungrx_web/presentation/bloc/get_dishes_by%20category/get_dishes_by_category_event.dart';
import 'package:hungrx_web/presentation/bloc/get_dishes_by%20category/get_dishes_by_category_state.dart';

class GetDishesByCategoryBloc extends Bloc<GetDishesByCategoryEvent, GetDishesByCategoryState> {
  final GetDishesByCategoryUseCase _useCase;

  GetDishesByCategoryBloc({
    GetDishesByCategoryUseCase? useCase,
  })  : _useCase = useCase ?? GetDishesByCategoryUseCase(),
        super(GetDishesByCategoryInitial()) {
    on<FetchDishesByCategoryEvent>(_onFetchDishesByCategory);
  }

  Future<void> _onFetchDishesByCategory(
    FetchDishesByCategoryEvent event,
    Emitter<GetDishesByCategoryState> emit,
  ) async {
    try {
      emit(GetDishesByCategoryLoading());

      final response = await _useCase.execute(
        restaurantId: event.restaurantId,
        categoryId: event.categoryId,
      );

      if (response.status) {
        emit(GetDishesByCategoryLoaded(response.data));
      } else {
        emit(GetDishesByCategoryError(response.message));
      }
    } catch (e) {
      emit(GetDishesByCategoryError(e.toString()));
    }
  }
}