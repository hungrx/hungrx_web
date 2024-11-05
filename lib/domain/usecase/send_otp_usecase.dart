import 'package:hungrx_web/core/utils/api_response.dart';
import 'package:hungrx_web/data/models/login_request.dart';
import 'package:hungrx_web/data/models/login_response.dart';
import 'package:hungrx_web/data/repositories/auth_repository_impl.dart';

class SendOtpUseCase {
  final AuthRepository repository;

  SendOtpUseCase(this.repository);

  Future<ApiResponse<LoginResponse>> execute(LoginRequest request) {
    return repository.sendOtp(request);
  }
}
