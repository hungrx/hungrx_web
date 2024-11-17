import 'package:hungrx_web/core/utils/api_response.dart';
import 'package:hungrx_web/data/datasource/api/otp_auth_api/auth_api_service.dart';
import 'package:hungrx_web/data/models/auth_models/login_request.dart';
import 'package:hungrx_web/data/models/auth_models/login_response.dart';
import 'package:hungrx_web/data/models/auth_models/otp_verification_request.dart';
import 'package:hungrx_web/data/models/auth_models/otp_verification_response.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _apiService;

  AuthRepositoryImpl({AuthApiService? apiService})
      : _apiService = apiService ?? AuthApiService();

  @override
  Future<ApiResponse<LoginResponse>> sendOtp(LoginRequest request) {
    return _apiService.sendOtp(request);
  }

  @override
  Future<ApiResponse<OtpVerificationResponse>> verifyOtp(
      OtpVerificationRequest request) {
    return _apiService.verifyOtp(request);
  }
}

// lib/domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<ApiResponse<LoginResponse>> sendOtp(LoginRequest request);
  Future<ApiResponse<OtpVerificationResponse>> verifyOtp(
      OtpVerificationRequest request);
}
