import 'package:shared_preferences/shared_preferences.dart';

// Save username
Future<void> saveUsername(String username) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', username);
}

// Get username
Future<String?> getUsername() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('username');
}


Future<void> saveToSharedPrefs(String key, String value) async{
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future<String?> getSharedPrefs(String key) async{
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

// Remove username (if needed)
Future<void> removeUsername() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('username');
}
