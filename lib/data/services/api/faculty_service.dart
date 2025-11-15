import 'dart:convert';
import 'dart:developer';

import 'package:attappv1/data/constants.dart';
import 'package:attappv1/data/network/auth_http_client.dart';
import 'package:attappv1/data/services/shared_prefs_service.dart';

final khttp = AuthHttpClient();

Future<String?> getFacultyName() async {
  String? username = await getUsername();
  if (username == null) {
    return null;
  }
  final facultyCode = username;

  try {
    final response = await khttp.get(
      Uri.parse('$baseUrl/faculties/$facultyCode/name'),
    );

    if (response.statusCode == 404) {
      return "Username Not Found.";
    }
    final json = jsonDecode(response.body);
    log(json.toString());
    // return json.name;
    return json["name"];
  } catch (e) {
    log(e.toString());
    return null;
  }
}
