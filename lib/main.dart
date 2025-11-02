import 'package:attappv1/ui/views/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl_standalone.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await findSystemLocale();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: SplashScreen()
    );
  }
}
