
import 'package:flutter/material.dart';
import '../services/secure_storage.dart';
import '../utils/jwt_utils.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _token;

  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;

  Future<void> loadToken() async {
    final storedToken = await
  }
}