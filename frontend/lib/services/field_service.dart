import 'dart:convert';
import 'dart:io';
import 'package:flutter/src/material/time.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/constants/area_type.dart';
import 'package:frontend/constants/pitch_type.dart';
import 'package:frontend/constants/surface_type.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class FieldService {

  static final fieldURL = dotenv.env['FIELD_URL']!;

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

  static Future<dynamic> createField({
    required String name,
    required String city,
    required String address,
    required String phone,
    required String mail,
    required bool isFree,
    PitchType? pitchType,
  }) async {
    final response = await http.post(
      Uri.parse('$fieldURL/api/fields/createField'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'city': city,
        'address': address,
        'phone': phone,
        'mail': mail,
        'isFree': isFree,
        'pitchType': pitchType?.name, // convert enum to string
      }),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['success'] == true) {
        return decoded['data']; // Return created field data or ID
      } else {
        throw Exception(decoded['message'] ?? 'Failed to create field');
      }
    } else {
      throw Exception('Failed to create field: ${response.statusCode}');
    }
  }

  static String formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return '';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static Future<bool> updateField({
    required String id,
    required String description,
    required String website,
    required bool canShower,
    required bool hasParking,
    required bool hasLighting,
    TimeOfDay? openingTime,
    TimeOfDay? lunchBrakeStart,
    TimeOfDay? lunchBrakeEnd,
    TimeOfDay? closingTime,
    required String price,
    SurfaceType? surfaceType,
    AreaType? areaType,
    required List<File> images, // Image upload is more complex
  }) async {
    final body = {
      'description': description,
      'website': website,
      'canShower': canShower,
      'hasParking': hasParking,
      'hasLighting': hasLighting,
      'openingTime': formatTimeOfDay(openingTime),
      'lunchBrakeStart': formatTimeOfDay(lunchBrakeStart),
      'lunchBrakeEnd': formatTimeOfDay(lunchBrakeEnd),
      'closingTime': formatTimeOfDay(closingTime),
      'price': price,
      'surfaceType': surfaceType?.name,
      'areaType': areaType?.name,
    };

    final response = await http.put(
      Uri.parse('$fieldURL/api/fields/$id/updateField'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['success'] == true;
    } else {
      throw Exception('Failed to update field');
    }
  }
}

