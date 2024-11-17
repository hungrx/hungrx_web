import 'package:hungrx_web/core/utils/api_response.dart';
import 'package:hungrx_web/data/models/auth_models/otp_verification_request.dart';
import 'package:hungrx_web/data/models/auth_models/otp_verification_response.dart';
import 'package:hungrx_web/data/repositories/auth_repo/auth_repository_impl.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<ApiResponse<OtpVerificationResponse>> execute(
    OtpVerificationRequest request
  ) {
    return repository.verifyOtp(request);
  }
}