import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class FieldService {

  static final String? fieldURL = Platform.isIOS
      ? dotenv.env['FIELD_URL']
      : 'http://192.168.49.2:30082';

  //Create a logger instance
  static final Logger logger = Logger();

  static Future<bool> checkFieldExistence({
    required String name,
    required String city,
    required String address,
  }) async {
    try {
      final uri = Uri.parse(
        '$fieldURL/api/fields/checkFieldExistence?fieldName=$name&city=$city&address=$address',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded == true;
      } else {
        final decoded = jsonDecode(response.body);
        final errorMsg = decoded['message'] ?? 'Pitch check failed';
        logger.e("checkFieldExistence failed: $errorMsg");
        return false;
      }
    } catch (e) {
      logger.e("Exception in checkFieldExistence: $e");
      return false;
    }
  }

  static Future<bool> loadImages() async {
    final response = await http.get(
        Uri.parse('$fieldURL/api/fields/uploadImages'));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['success'] == true;
    } else {
      final errorMsg = jsonDecode(response.body)['message'] ?? 'Load failed';
      logger.e("Loading images failed due to: $errorMsg");
      throw Exception('Fail to load images');
    }
  }

}

