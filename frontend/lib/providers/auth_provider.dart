
import 'package:flutter/material.dart';
import '../services/secure_storage.dart';
import '../utils/jwt_utils.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _token;

  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;

  Future<void> loadToken() async {
    final storedToken = await SecureStorage.readToken();
    if (storedToken != null && storedToken.isNotEmpty && JwtUtils.isTokenExpired(storedToken)) {
      _token = storedToken;
      _isLoggedIn = true;
    }
    notifyListeners();
  }

  Future<void> login(String token) async {
    await SecureStorage.writeToken(token);
    _token = token;
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await SecureStorage.deleteToken();
    _token = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}