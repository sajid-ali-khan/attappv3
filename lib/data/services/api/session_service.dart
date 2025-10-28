import 'dart:convert';
import 'dart:developer';

import 'package:attappv1/data/constants.dart';
import 'package:attappv1/data/models/session_model/session_model.dart';
import 'package:attappv1/data/network/auth_http_client.dart';
import 'package:attappv1/data/services/shared_prefs_service.dart';
import 'package:intl/intl.dart';

final khttp = AuthHttpClient();

Future<SessionModel?> createNewSession(int courseId) async {
  String? username = await getUsername();
  if (username == null) return null;

  Map<String, dynamic> queryParams = {
    "courseId": courseId,
    "facultyCode": username
  };
  final response = await khttp.post(
    Uri.http(baseUrlAddress, '/api/sessions', queryParams)
  );

  if (response.statusCode == 200){
    final json = SessionModel.fromJson(jsonDecode(response.body));
    return json;
  }
  return null;
}

Future<List<SessionModel>> fetchSessions(int classId, DateTime date) async{
  final response = await khttp.get(
    Uri.parse('$baseUrl/sessions?courseId=$classId&date=${DateFormat('y-M-d').format(date)}')
  );
  if (response.statusCode == 200){
    final json = jsonDecode(response.body) as List;
    List<SessionModel> sessions = [];
    for (Map<String, dynamic> j in json){
      sessions.add(SessionModel.fromJson(j));
      log(j.toString());
    }
    return sessions;
  }
  return [];
}