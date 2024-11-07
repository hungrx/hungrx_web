class AddCategoryResponse {
  final bool status;
  final String message;

  AddCategoryResponse({
    required this.status,
    required this.message,
  });

  factory AddCategoryResponse.fromJson(Map<String, dynamic> json) {
    return AddCategoryResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? 'Unknown response',
    );
  }
}