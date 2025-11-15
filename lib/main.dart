import 'package:attappv1/ui/viewmodels/auth_provider.dart';
import 'package:attappv1/ui/viewmodels/class_provider.dart';
import 'package:attappv1/ui/viewmodels/classes_provider.dart';
import 'package:attappv1/ui/viewmodels/report_provider.dart';
import 'package:attappv1/ui/viewmodels/session_provider.dart';
import 'package:attappv1/ui/views/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_standalone.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('en_IN', null);
  await findSystemLocale();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ClassesProvider()),
        ChangeNotifierProvider(create: (_) => SessionProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => ClassProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: SplashScreen(),
    );
  }
}
