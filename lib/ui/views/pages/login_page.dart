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
  @override
  Widget build(BuildContext context) {
    bool obscureText = true;
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(32),
        child: Column(
          spacing: 24,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Column(
              spacing: 10,
              children: [
                Text('Welcome back!', style: TextStyle(fontSize: 24)),
                Text('Sign in to manage attendance'),
              ],
            ),
            Column(
              spacing: 16,
              children: [
                TextField(
                  controller: usernameController,
                  keyboardType: TextInputType.numberWithOptions(signed: true),
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter your userId',
                  ),
                ),

                TextField(
                  controller: passwordController,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: 'Enter your password',
                    suffixIcon: IconButton(
                      icon: obscureText
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          obscureText =
                              !obscureText; // Toggle password visibility
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
                      await context.read<AuthProvider>().login(
                        usernameController.text.trim(),
                        passwordController.text.trim(),
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
