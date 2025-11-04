import 'package:attappv1/data/models/login_request/login_request.dart';
import 'package:attappv1/data/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';


class AuthProvider extends ChangeNotifier{
  final AuthRepository _authRepository = AuthRepository();
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get errorMessage => _errorMessage;


  Future<void> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authRepository.loginUser(
      LoginRequest(username: username, password: password)
    );

    _isLoading = false;
    if (result['success']) {
      _isLoggedIn = true;
    } else {
      _isLoggedIn = false;
      _errorMessage = result['message'];
    }

    notifyListeners();
  }

}