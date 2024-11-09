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
    try {
      var uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.editRestaurant}');
      var request = http.MultipartRequest('PUT', uri);

      request.fields['restaurantId'] = restaurantId;
      request.fields['name'] = name;
      request.fields['categoryId'] = categoryId;
      request.fields['rating'] = rating.toString();
      request.fields['description'] = description;

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

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw EditRestaurantServerException('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw EditRestaurantNetworkException('Network error: $e');
    }
  }
}