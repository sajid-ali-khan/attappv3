import 'dart:convert';
import 'dart:developer';

import 'package:attappv1/data/constants.dart';
import 'package:attappv1/data/models/jwt_response/jwt_response.dart';
import 'package:attappv1/data/models/login_request/login_request.dart';
import 'package:attappv1/data/network/auth_http_client.dart';
import 'package:attappv1/data/services/shared_prefs_service.dart';
import 'package:attappv1/data/services/token_service.dart';

class AuthRepository {
  final AuthHttpClient _httpClient = AuthHttpClient();
  final TokenService _tokenService = TokenService();

  Future<Map<String, dynamic>> loginUser(LoginRequest loginRequest) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl/auth/login'),
        body: jsonEncode(loginRequest.toJson()),
      );

      if (response.statusCode == 200) {
        final jwtResponse = JwtResponse.fromJson(jsonDecode(response.body));

        await _tokenService.saveToken(jwtResponse.token);
        await saveUsername(jwtResponse.username);
        return {'success': true};
      } else {
        log('Login failed: ${response.body}');
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e, stack) {
      log('Error logging in: $e\n$stack');

      return {'success': false, 'message': 'Something went wrong.'};
    }
  }
}
