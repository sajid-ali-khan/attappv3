import 'package:attappv1/ui/viewmodels/auth_provider.dart';
import 'package:attappv1/ui/views/pages/dashboard_page.dart';
import 'package:attappv1/ui/views/widgets/shared.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(32),
        child: Column(
          spacing: 32,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Column(
              spacing: 10,
              children: [
                Text('Login', style: TextStyle(fontSize: 24)),
                Text('to continue to Attendance Management'),
              ],
            ),
            Column(
              spacing: 16,
              children: [
                TextField(
                  controller: _usernameController,
                  keyboardType: TextInputType.numberWithOptions(signed: true),
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter your userId',
                  ),
                ),

                TextField(
                  controller: _passwordController,
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
                          _obscureText = !_obscureText; // Toggle password visibility
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            auth.isLoading
                ? const CircularProgressIndicator()
                : FilledButton(
                    onPressed: () async {
                      if (_usernameController.text.trim() == '' ||
                          _passwordController.text.trim() == '') {
                        if (!context.mounted) return;
                        showMySnackbar(
                          context,
                          'Please enter both userId and password.',
                        );
                        return;
                      }
                      await context.read<AuthProvider>().login(
                        _usernameController.text.trim(),
                        _passwordController.text.trim(),
                      );

                      if (!context.mounted) return;

                      if (auth.isLoggedIn) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DashboardPage(),
                          ),
                        );
                      } else if (auth.errorMessage != null) {
                        showMySnackbar(context, auth.errorMessage!);
                      }
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
                    ),
                    child: Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}
