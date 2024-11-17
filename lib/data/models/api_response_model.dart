class ApiResponseModel<T> {
  final bool status;
  final String message;
  final T? data;

  ApiResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory ApiResponseModel.fromJson(Map<String, dynamic> json, T? Function(Map<String, dynamic>) fromJson) {
    return ApiResponseModel(
      status: json['status']??false,
      message: json['message']??"",
      data: json['category'] != null ? fromJson(json['category']) : null,
    );
  }
}