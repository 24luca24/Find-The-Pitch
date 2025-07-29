import 'package:jwt_decoder/jwt_decoder.dart';

class JwtUtils {
  static bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  static Map<String, dynamic> getPayload(String token) {
    return JwtDecoder.decode(token);
  }

  static String? getUserRole(String token) {
    final payload = getPayload(token);
    return payload['role'];
  }
}