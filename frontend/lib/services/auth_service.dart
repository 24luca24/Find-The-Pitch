import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {

  static final authURL = dotenv.env['AUTH_URL']!;

  // Create a logger instance
  static final Logger logger = Logger();

  static Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String city,
  }) async {
    final url = Uri.parse("$authURL/api/auth/register");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
          "city": city,
          "role": "user",
        }),
      );
      logger.i('Response status: ${response.statusCode}');
      logger.i('Response body: ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      logger.e('Error during register: $e');
      return false;
    }
  }

  static Future<bool> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse("$authURL/api/auth/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);

      return true;
    }

    return false;
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  //To retrieve city for autocompletion
  static Future<List<String>> fetchCitySuggestions(String query) async {
    final url = Uri.parse('$authURL/api/cities/autocomplete?prefix=$query');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> cities = jsonDecode(response.body);
        return cities.map<String>((city) => city.toString()).toList();
      } else {
        logger.e('Failed to fetch cities: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      logger.e('Error fetching city suggestions: $e');
      return [];
    }
  }

  //Check availability of username
  static Future<bool> checkUsernameAvailable(String username) async {
    try {
      final response = await http.get(
        Uri.parse('$authURL/users/check-username?name=$username'),
      );

      if (response.statusCode == 200) {
        return response.body == 'true';
      } else {
        String errorMsg;

        try {
          final decoded = jsonDecode(response.body);
          errorMsg = decoded['message'] ?? 'Unknown error';
        } catch (_) {
          errorMsg = 'Non-JSON response: ${response.body}';
        }

        logger.e('Registration failed: $errorMsg');
        throw Exception('Failed to check username: $errorMsg');
      }
    } catch (e, stackTrace) {
      logger.e('Exception in checkUsernameAvailable: $e');
      logger.e('Stack trace: $stackTrace');
      rethrow;
    }
  }

}
