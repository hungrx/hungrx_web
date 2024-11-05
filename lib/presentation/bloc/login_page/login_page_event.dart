abstract class PhoneLoginEvent {}

class PhoneLoginSubmitted extends PhoneLoginEvent {
  final String name;
  final String phoneNumber;

  PhoneLoginSubmitted({
    required this.name,
    required this.phoneNumber,
  });
}