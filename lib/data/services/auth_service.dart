import 'dart:convert';
import 'dart:developer';
import 'package:attappv1/data/constants.dart';
import 'package:attappv1/data/models/jwt_response/jwt_response.dart';
import 'package:attappv1/data/models/login_request/login_request.dart';
import 'package:attappv1/data/network/auth_http_client.dart';
import 'package:attappv1/data/services/shared_prefs_service.dart';
import 'package:attappv1/data/services/token_service.dart';

final AuthHttpClient khttp = AuthHttpClient();
final TokenService _tokenService = TokenService();

Future<JwtResponse?> loginUser(LoginRequest loginRequest) async {
  final response = await khttp.post(
    Uri.parse('$baseUrl/auth/login'),
    body: jsonEncode(loginRequest.toJson()),
  );

  if (response.statusCode == 200) {
    log('Success. ${response.body}');
    final jwtResponse =  JwtResponse.fromJson(jsonDecode(response.body));

    await _tokenService.saveToken(jwtResponse.token);
    await saveUsername(jwtResponse.username);
    return jwtResponse;
  } else {
    log('Failed. ${response.body}');
    return null;
  }
}
