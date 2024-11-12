import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:hungrx_web/core/constant/api_constant.dart';
import 'dart:convert';
import 'package:hungrx_web/core/error/exceptions.dart';

class EditRestaurantApi {
  final client = http.Client();

  Future<Map<String, dynamic>> updateRestaurant({
    required String restaurantId,
    required String name,
    required String categoryId,
    required double rating,
    required String description,
    Uint8List? logoBytes,
    String? logoName,
  }) async {
    try {
      var uri =
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.editRestaurant}');
      var request = http.MultipartRequest('PUT', uri);

      // Add all text fields
      request.fields.addAll({
        'restaurantId': restaurantId,
        'name': name,
        'category': categoryId,
        'rating': rating.toString(),
        'description': description,
      });
// print(categoryId);
// print(restaurantId);
// print(description);
      // Handle image file if provided
      if (logoBytes != null && logoName != null) {
        // Determine file extension from logoName
        final fileExtension = logoName.split('.').last.toLowerCase();
        final mimeType = _getMimeType(fileExtension);

        // Create multipart file with proper content type
        var multipartFile = http.MultipartFile.fromBytes(
          'logo',
          logoBytes,
          filename: logoName,
          contentType: MediaType('image', mimeType),
        );
        request.files.add(multipartFile);
      }

      // Send request and handle response
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw EditRestaurantNetworkException('Request timeout');
        },
      );

      final response = await http.Response.fromStream(streamedResponse);

      // Log response for debugging
      print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
print(streamedResponse.headers);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        if (responseData['status'] == true) {
          return responseData;
        } else {
          print(responseData['message']);
          throw EditRestaurantServerException(
            responseData['message'] ?? 'Failed to update restaurant',
          );
          
        }
        
      } else {
        // Try to parse error message from response
        String errorMessage;
        try {
          final errorData = json.decode(response.body);
          errorMessage = errorData['message'] ?? 'Unknown server error';
        } catch (_) {
          errorMessage = 'Server error: ${response.statusCode}';
        }
        throw EditRestaurantServerException(errorMessage);
      }
    } on EditRestaurantServerException {
      rethrow;
    } on EditRestaurantNetworkException {
      rethrow;
    } catch (e) {
      throw EditRestaurantNetworkException('Network error: $e');
    }
  }

  String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'jpeg';
      case 'png':
        return 'png';
      case 'gif':
        return 'gif';
      case 'webp':
        return 'webp';
      default:
        return 'jpeg'; // default to jpeg
    }
  }
}
