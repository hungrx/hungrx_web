import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hungrx_web/core/constant/api_constant.dart';
import 'package:hungrx_web/data/models/add_restaurant_model.dart';
import 'package:http_parser/http_parser.dart';
class AddRestaurantApiClient {
  final http.Client client;

  AddRestaurantApiClient({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> addRestaurant(AddRestaurantModel restaurant) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.addRestaurant}');
      
      var request = http.MultipartRequest('POST', uri);
      
      // Add text fields
      request.fields.addAll(restaurant.toFormData());

      // Add logo file if available
      if (restaurant.logoBytes != null && restaurant.logoName != null) {
        final multipartFile = http.MultipartFile.fromBytes(
          'logo',
          restaurant.logoBytes!,
          filename: restaurant.logoName!,
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
      }

      final response = await request.send();
      
      final responseData = await response.stream.bytesToString();
      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(responseData);
      } else {
        throw Exception('Failed to add restaurant: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}