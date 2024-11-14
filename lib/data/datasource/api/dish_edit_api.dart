import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:hungrx_web/core/constant/api_constant.dart';
import 'dart:convert';
import 'package:hungrx_web/core/error/exceptions.dart';

class DishEditApi {
  final client = http.Client();

  Future<Map<String, dynamic>> updateDish({
    required String name,
    required double price,
    required double rating,
    required String description,
    required String calories,
    required String carbs,
    required String protein,
    required String fats,
    required String servingSize,
    required String servingUnit,
    required String categoryId,
    required String restaurantId,
    required String menuId,
    required String dishId,
    required String subcategoryId,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    try {
      var uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.editDish}');
      var request = http.MultipartRequest('PUT', uri);

      // Add all text fields
      request.fields.addAll({
        'name': name,
        'price': price.toString(),
        'rating': rating.toString(),
        'description': description,
        'calories': calories,
        'carbs': carbs,
        'protein': protein,
        'fats': fats,
        'servingSize': servingSize,
        'servingUnit': servingUnit,
        'categoryId': categoryId,
        'restaurantId': restaurantId,
        'menuId': menuId,
        'dishId': dishId,
        'subcategoryId': subcategoryId,
      });

      // Handle image file if provided
      if (imageBytes != null && imageName != null) {
        final fileExtension = imageName.split('.').last.toLowerCase();
        final mimeType = _getMimeType(fileExtension);

        var multipartFile = http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: imageName,
          contentType: MediaType('image', mimeType),
        );
        request.files.add(multipartFile);
      }

      // Send request and handle response
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw DishEditServerException('Request timeout');
        },
      );

      final response = await http.Response.fromStream(streamedResponse);
print(response.body);
print(response.statusCode);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          return responseData;
        } else {
          throw DishEditServerException(
            responseData['message'] ?? 'Failed to update dish',
          );
        }
      } else {
        String errorMessage;
        try {
          final errorData = json.decode(response.body);
          errorMessage = errorData['message'] ?? 'Unknown server error';
        } catch (_) {
          errorMessage = 'Server error: ${response.statusCode}';
        }
        throw DishEditServerException(errorMessage);
      }
    } on DishEditServerException {
      rethrow;
    } on DishEditNetworkException {
      rethrow;
    } catch (e) {
      throw DishEditNetworkException('Network error: $e');
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
        return 'jpeg';
    }
  }
}