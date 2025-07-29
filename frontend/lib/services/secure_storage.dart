
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final _storage = FlutterSecureStorage();

  static const _tokenKey = 'jwt_token';

  //Write token -> saves the JWT token
  static Future<void> writeToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  //Read token -> fetch the token, null if none
  static Future<String?> readToken() async {
    return await _storage.read(key: _tokenKey);
  }

  //Delete token -> removes it on logout or token invalidation
  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  //Clear all data stored -> clears everything, useful to reset storage fully
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}