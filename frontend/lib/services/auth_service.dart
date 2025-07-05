import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseURL = 'http://127.0.0.1:8080';

  // Create a logger instance
  static final Logger logger = Logger();

  static Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String city,
  }) async {
    final url = Uri.parse("$baseURL/api/auth/register");
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
    final url = Uri.parse("$baseURL/api/auth/login");
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
}
