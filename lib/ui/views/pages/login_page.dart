import 'dart:developer';

import 'package:attappv1/data/models/login_request/login_request.dart';
import 'package:attappv1/data/services/api/auth_service.dart';
import 'package:attappv1/ui/views/pages/dashboard_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Welcome back!', style: TextStyle(fontSize: 24)),
              Text('Sign in to manage attendance'),
              SizedBox(height: 30),
              TextField(
                controller: usernameController,
                keyboardType: TextInputType.numberWithOptions(signed: true),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your userId',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  labelText: 'Enter your password',
                  suffixIcon: IconButton(
                    icon: _obscureText
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureText =
                            !_obscureText; // Toggle password visibility
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 30),
              FilledButton(
                onPressed: () async {
                  String username = usernameController.text.trim();
                  String password = passwordController.text.trim();

                  log('username: $username, password: $password');

                  if (username == '' || password == '') {
                    return;
                  }

                  LoginRequest loginRequest = LoginRequest(
                    username: username,
                    password: password,
                  );
                  await loginUser(loginRequest).then(
                    (value) => {
                      if (value == null)
                        {log('login failed.')}
                      else
                        {
                          log('login success'),
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Login successful.'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          ),
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return DashboardPage();
                              },
                            ),
                          ),
                        },
                    },
                  );
                },
                style: FilledButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                ),
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
