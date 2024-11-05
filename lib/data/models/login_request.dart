class LoginRequest {
  final String mobile;
  final String name;

  LoginRequest({required this.mobile, required this.name});

  Map<String, dynamic> toJson() => {
    'mobile': '+91$mobile',
    'name': name,
  };
}