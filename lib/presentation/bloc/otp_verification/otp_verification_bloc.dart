import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_web/data/models/auth_models/login_request.dart';
import 'package:hungrx_web/data/models/auth_models/otp_verification_request.dart';
import 'package:hungrx_web/data/repositories/auth_repo/auth_repository_impl.dart';
import 'package:hungrx_web/domain/usecase/auth_usecase/send_otp_usecase.dart';
import 'package:hungrx_web/domain/usecase/auth_usecase/verify_otp_usecase.dart';
import 'package:hungrx_web/presentation/bloc/otp_verification/otp_verification_event.dart';
import 'package:hungrx_web/presentation/bloc/otp_verification/otp_verification_state.dart';

class OtpVerificationBloc extends Bloc<OtpVerificationEvent, OtpVerificationState> {
  final VerifyOtpUseCase _verifyOtpUseCase;
  final SendOtpUseCase _sendOtpUseCase;

  OtpVerificationBloc({
    VerifyOtpUseCase? verifyOtpUseCase,
    SendOtpUseCase? sendOtpUseCase,
  }) : _verifyOtpUseCase = verifyOtpUseCase ?? 
            VerifyOtpUseCase(AuthRepositoryImpl()),
       _sendOtpUseCase = sendOtpUseCase ??
            SendOtpUseCase(AuthRepositoryImpl()),
       super(OtpVerificationInitial()) {
    on<OtpVerificationSubmitted>(_onOtpVerificationSubmitted);
    on<ResendOtpRequested>(_onResendOtpRequested);
  }

  Future<void> _onOtpVerificationSubmitted(
    OtpVerificationSubmitted event,
    Emitter<OtpVerificationState> emit,
  ) async {
    emit(OtpVerificationLoading());

    try {
      final request = OtpVerificationRequest(
        name: event.name,
        mobile: event.phoneNumber,
        otp: event.otp,
      );

      final response = await _verifyOtpUseCase.execute(request);

      if (response.success) {
        emit(OtpVerificationSuccess(
          message: response.data?.message ?? 'OTP verified successfully',
        ));
      } else {
        emit(OtpVerificationFailure(
          response.error ?? 'Failed to verify OTP'
        ));
      }
    } catch (e) {
      emit(OtpVerificationFailure('An unexpected error occurred'));
    }
  }

 Future<void> _onResendOtpRequested(
    ResendOtpRequested event,
    Emitter<OtpVerificationState> emit,
  ) async {
    emit(OtpVerificationLoading());

    try {
      final request = LoginRequest(
        mobile: event.phoneNumber,
        name: event.name,
      );

      final response = await _sendOtpUseCase.execute(request);

      if (response.success) {
        emit(OtpResendSuccess(
          message: response.data?.message ?? 'OTP resent successfully'
        ));
      } else {
        emit(OtpResendFailure(
          response.error ?? 'Failed to resend OTP'
        ));
      }
    } catch (e) {
      emit(OtpResendFailure('An unexpected error occurred'));
    }
  }
}
