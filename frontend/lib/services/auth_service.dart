import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String city,
  }) async {
    final url = Uri.parse("http://localhost:8080/api/auth/register");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": password,
        "city": city,
        "role": "USER",
      }),
    );
    return response.statusCode == 200;
  }
}
