import 'package:attappv1/data/services/token_service.dart';
import 'package:attappv1/ui/views/pages/dashboard_page.dart';
import 'package:attappv1/ui/views/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final TokenService _tokenService = TokenService();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    String? token = await _tokenService.getToken();

    if (token == null) {
      navigateToLogin();
      return;
    }

    bool hasExpired = JwtDecoder.isExpired(token);

    if (hasExpired) {
      await _tokenService.deleteToken();
      navigateToLogin();
    } else {
      navigateToDashboard();
    }
  }

  void navigateToLogin() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
  }

  void navigateToDashboard() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardPage(),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
