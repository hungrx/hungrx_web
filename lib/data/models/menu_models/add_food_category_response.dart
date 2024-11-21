class AddFoodCategoryResponse {
  final bool status;
  final String message;

  AddFoodCategoryResponse({
    required this.status,
    required this.message,
  });

  factory AddFoodCategoryResponse.fromJson(Map<String, dynamic> json) {
    return AddFoodCategoryResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? 'Unknown error occurred',
    );
  }
}
