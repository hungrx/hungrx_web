class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool success;

  ApiResponse({
    this.data,
    this.error,
    this.success = true,
  });

  factory ApiResponse.success(T data) => ApiResponse(data: data);
  factory ApiResponse.error(String message) => 
      ApiResponse(error: message, success: false);
}