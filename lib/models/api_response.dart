// lib/models/api_response.dart
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final String? error;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
  });

  factory ApiResponse.success(T data, {String message = 'Success'}) {
    return ApiResponse(success: true, message: message, data: data);
  }

  factory ApiResponse.error(String error) {
    return ApiResponse(success: false, message: 'Error', error: error);
  }
}
