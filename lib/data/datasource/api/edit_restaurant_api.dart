import 'dart:typed_data';
import 'package:http/http.dart' as http;
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
    print(logoName);
    print(logoBytes!=null);
    try {
      var uri =
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.editRestaurant}');
      var request = http.MultipartRequest('PUT', uri);

      request.fields.addAll({
        'restaurantId':restaurantId,
        'name': name,
        'categoryId': categoryId,
        'rating': rating.toString(),
        'description': description,
      });

      if (logoBytes != null && logoName != null) {
        var multipartFile = http.MultipartFile.fromBytes(
          'logo',
          logoBytes,
          filename: logoName,
        );
        request.files.add(multipartFile);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
print(response.body);
print(response.statusCode);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          return responseData;
        } else {
          throw EditRestaurantServerException(
            responseData['message'] ?? 'Failed to update restaurant',
          );
        }
      } else {
        throw EditRestaurantServerException(
          'Server error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      if (e is EditRestaurantServerException) {
        rethrow;
      }
      throw EditRestaurantNetworkException('Network error: $e');
    }
  }
}
