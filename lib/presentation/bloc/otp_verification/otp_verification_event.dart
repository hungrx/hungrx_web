abstract class OtpVerificationEvent {}

class OtpVerificationSubmitted extends OtpVerificationEvent {
  final String name;
  final String phoneNumber;
  final String otp;

  OtpVerificationSubmitted({
    required this.name,
    required this.phoneNumber,
    required this.otp,
  });
}

class ResendOtpRequested extends OtpVerificationEvent {
  final String phoneNumber;
  final String name;

  ResendOtpRequested({
    required this.phoneNumber,
    required this.name,
  });
}