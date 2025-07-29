import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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

  //Token section
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  //To check whether someone is logged or not
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  static Future<bool> isTokenExpired() async {
    final token = await getToken();
    if (token == null) return true;
    return JwtDecoder.isExpired(token);
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
        Uri.parse('$authURL/api/users/check-username?name=$username'),
      );

      if (response.statusCode == 200) {
        return response.body.trim().toLowerCase() == 'true';
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

  //Check availability of email
  static Future<bool> checkEmailAvailable(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$authURL/api/users/check-email?email=$email'),
      );

      if (response.statusCode == 200) {
        return response.body.trim().toLowerCase() == 'true';
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

  //Centralized authenticated GET request
  static Future<http.Response> authenticatedGet(String path) async {
    final headers = await getAuthHeaders();
    final url = Uri.parse('$authURL$path');
    return http.get(url, headers: headers);
  }

  //Centralized authenticated POST request
  static Future<http.Response> authenticatedPost(String path, Map<String, dynamic> body) async {
    final headers = await getAuthHeaders();
    final url = Uri.parse('$authURL$path');
    return http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }
}
