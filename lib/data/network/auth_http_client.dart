// lib/data/network/auth_http_client.dart

import 'package:attappv1/data/services/token_service.dart';
import 'package:attappv1/main.dart';
import 'package:attappv1/ui/viewmodels/connection_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// Create a single, reusable instance of the service
final TokenService _tokenService = TokenService();

class AuthHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final connectionProvider = navigatorKey.currentContext!.read<ConnectionProvider>();

    bool ok = await connectionProvider.checkServerOnce();
    if (!ok) {
      throw Exception("SERVER_UNREACHABLE");
    }

    final token = await _tokenService.getToken();
    request.headers['Content-Type'] = 'application/json; charset=UTF-8';

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    return _inner.send(request);
  }
}
