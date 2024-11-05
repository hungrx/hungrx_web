abstract class OtpVerificationState {}

class OtpVerificationInitial extends OtpVerificationState {}

class OtpVerificationLoading extends OtpVerificationState {}

class OtpVerificationSuccess extends OtpVerificationState {
  final String message;

  OtpVerificationSuccess({required this.message});
}

class OtpVerificationFailure extends OtpVerificationState {
  final String error;

  OtpVerificationFailure(this.error);
}
class OtpResendSuccess extends OtpVerificationState {
  final String message;

  OtpResendSuccess({required this.message});
}

class OtpResendFailure extends OtpVerificationState {
  final String error;

  OtpResendFailure(this.error);
}