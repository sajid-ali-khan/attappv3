import 'dart:convert';
import 'dart:developer';

import 'package:attappv1/data/constants.dart';
import 'package:attappv1/data/models/session_model/session_model.dart';
import 'package:attappv1/data/models/session_register/session_register.dart';
import 'package:attappv1/data/network/auth_http_client.dart';
import 'package:attappv1/data/services/shared_prefs_service.dart';
import 'package:intl/intl.dart';

final khttp = AuthHttpClient();

Future<SessionModel?> createNewSession(int courseId) async {
  String? username = await getUsername();
  if (username == null) return null;

  Map<String, dynamic> queryParams = {
    "courseId": courseId,
    "facultyCode": username,
  };
  final response = await khttp.post(
    Uri.http(baseUrlAddress, '/api/sessions', queryParams),
  );

  if (response.statusCode == 200) {
    final json = SessionModel.fromJson(jsonDecode(response.body));
    return json;
  }
  return null;
}

Future<Map<int, SessionModel>> fetchSessions(int classId, DateTime date) async {
  final response = await khttp.get(
    Uri.parse(
      '$baseUrl/sessions?courseId=$classId&date=${DateFormat('y-M-d').format(date)}',
    ),
  );
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);

    return data.map(
      (key, value) => MapEntry(int.parse(key), SessionModel.fromJson(value)),
    );
  } else {
    throw Exception('Failed to load sessions');
  }
}

Future<SessionRegister?> fetchSessionRegister(int sessionId) async {
  final response = await khttp.get(Uri.parse('$baseUrl/sessions/$sessionId'));

  if (response.statusCode == 200) {
    log('get: sessionRegister/$sessionId successfull');
    return SessionRegister.fromJson(jsonDecode(response.body));
  }
  return null;
}

Future<bool> deleteSession(int sessionId) async {
  final response = await khttp.delete(
    Uri.parse('$baseUrl/sessions/$sessionId'),
  );

  return response.statusCode == 200;
}
