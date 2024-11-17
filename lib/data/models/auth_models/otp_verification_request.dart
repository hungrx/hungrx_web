class OtpVerificationRequest {
  final String mobile;
  final String otp;
  final String name;

  OtpVerificationRequest({
    required this.name,
    required this.mobile,
    required this.otp,
  });

  Map<String, dynamic> toJson() => {
    'name':name,
    'mobile': '+91$mobile',
    'otp': otp,
  };
}