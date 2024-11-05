abstract class PhoneLoginState {}

class PhoneLoginInitial extends PhoneLoginState {}

class PhoneLoginLoading extends PhoneLoginState {}

class PhoneLoginSuccess extends PhoneLoginState {
  final String name;
  final String phoneNumber;
  final String message;

  PhoneLoginSuccess({
    required this.name,
    required this.phoneNumber,
    required this.message,
  });
}

class PhoneLoginFailure extends PhoneLoginState {
  final String error;

  PhoneLoginFailure(this.error);
}