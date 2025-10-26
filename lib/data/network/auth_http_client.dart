// lib/data/network/auth_http_client.dart

import 'package:attappv1/data/services/token_service.dart';
import 'package:http/http.dart' as http;

// Create a single, reusable instance of the service
final TokenService _tokenService = TokenService();

class AuthHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  // The send method is called for every network request.
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // 1. Retrieve the token asynchronously
    final token = await _tokenService.getToken(); 

    // 2. Inject the headers BEFORE sending the request
    request.headers['Content-Type'] = 'application/json; charset=UTF-8';
    
    if (token != null) {
      // The standard way to send a JWT
      request.headers['Authorization'] = 'Bearer $token';
    }

    // 3. Forward the modified request to the actual inner client
    return _inner.send(request);
  }
}