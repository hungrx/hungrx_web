import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hungrx_web/core/constant/api_constant.dart';
import 'package:hungrx_web/core/utils/api_response.dart';
import 'package:hungrx_web/data/models/auth_models/login_request.dart';
import 'package:hungrx_web/data/models/auth_models/login_response.dart';
import 'package:hungrx_web/data/models/auth_models/otp_verification_request.dart';
import 'package:hungrx_web/data/models/auth_models/otp_verification_response.dart';

class AuthApiService {
  final http.Client client;

  AuthApiService({http.Client? client}) : client = client ?? http.Client();

  Future<ApiResponse<LoginResponse>> sendOtp(LoginRequest request) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.sendOtp}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = LoginResponse.fromJson(jsonDecode(response.body));
        return ApiResponse.success(data);
      } else {
        final error = jsonDecode(response.body);
        return ApiResponse.error(error['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  Future<ApiResponse<OtpVerificationResponse>> verifyOtp(
    OtpVerificationRequest request
  ) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}/admin/verifyOTP'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
      if (response.statusCode == 200) {
        final data = OtpVerificationResponse.fromJson(jsonDecode(response.body));
        return ApiResponse.success(data);
      } else {
        final error = jsonDecode(response.body);
        return ApiResponse.error(error['message'] ?? 'OTP verification failed');
      }
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }
}

