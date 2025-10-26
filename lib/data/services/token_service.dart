// lib/services/token_service.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  // 1. Static, private instance field
  static final TokenService _instance = TokenService._internal();

  // 2. Factory constructor to return the same instance every time
  factory TokenService() {
    return _instance;
  }

  // 3. Private constructor (prevents external instantiation)
  TokenService._internal(); 

  // --- Dependencies and Methods ---
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _tokenKey = 'jwt_token';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}