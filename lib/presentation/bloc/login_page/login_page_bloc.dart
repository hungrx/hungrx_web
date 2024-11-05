import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/data/models/login_request.dart';
import 'package:hungrx_web/data/repositories/auth_repository_impl.dart';
import 'package:hungrx_web/domain/usecase/send_otp_usecase.dart';
import 'package:hungrx_web/presentation/bloc/login_page/login_page_event.dart';
import 'package:hungrx_web/presentation/bloc/login_page/login_page_state.dart';

class PhoneLoginBloc extends Bloc<PhoneLoginEvent, PhoneLoginState> {
  final SendOtpUseCase _sendOtpUseCase;

  PhoneLoginBloc({SendOtpUseCase? sendOtpUseCase})
      : _sendOtpUseCase = sendOtpUseCase ?? 
            SendOtpUseCase(AuthRepositoryImpl()),
        super(PhoneLoginInitial()) {
    on<PhoneLoginSubmitted>(_onPhoneLoginSubmitted);
  }

  Future<void> _onPhoneLoginSubmitted(
    PhoneLoginSubmitted event,
    Emitter<PhoneLoginState> emit,
  ) async {
    emit(PhoneLoginLoading());

    try {
      final request = LoginRequest(
        mobile: event.phoneNumber,
        name: event.name,
      );

      final response = await _sendOtpUseCase.execute(request);

      if (response.success) {
        emit(PhoneLoginSuccess(
          name: event.name,
          phoneNumber: event.phoneNumber,
          message: response.data?.message ?? 'OTP sent successfully',
        ));
      } else {
        emit(PhoneLoginFailure(response.error ?? 'Failed to send OTP'));
      }
    } catch (e) {
      emit(PhoneLoginFailure('An unexpected error occurred'));
    }
  }
}