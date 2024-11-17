class OtpVerificationResponse {
  final bool success;
  final String message;
  final String? token;

  OtpVerificationResponse({
    required this.success,
    required this.message,
    this.token,
  });

  factory OtpVerificationResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerificationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'],
    );
  }
}