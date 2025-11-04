import 'dart:convert';
import 'dart:developer';

import 'package:attappv1/data/constants.dart';
import 'package:attappv1/data/models/session_model/session_model.dart';
import 'package:attappv1/data/models/session_register/session_register.dart';
import 'package:attappv1/data/network/auth_http_client.dart';
import 'package:attappv1/data/services/shared_prefs_service.dart';
import 'package:intl/intl.dart';

class SessionRepository {
  final AuthHttpClient _httpClient = AuthHttpClient();

  Future<Map<String, dynamic>> fetchSessions(int classId, DateTime date) async {
    try {
      final response = await _httpClient.get(
        Uri.parse(
          '$baseUrl/sessions?courseId=$classId&date=${DateFormat('yyyy-MM-dd').format(date)}',
        ),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final sessionMap = data.map(
          (key, value) =>
              MapEntry(int.parse(key), SessionModel.fromJson(value)),
        );

        return {'success': true, 'sessionMap': sessionMap};
      } else {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e, stack) {
      log('Error logging in: $e\n$stack');
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  Future<Map<String, dynamic>> deleteSession(int sessionId) async {
    try {
      final response = await _httpClient.delete(
        Uri.parse('$baseUrl/sessions/$sessionId'),
      );

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        return jsonDecode(response.body);
      }
    } catch (e, stack) {
      log('Error logging in: $e\n$stack');
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  Future<Map<String, dynamic>> createNewSession(int courseId) async {
    try {
      String? username = await getUsername();
      if (username == null) {
        return {'success': false, 'message': 'Could\'t fetch username'};
      }

      final response = await _httpClient.post(
        Uri.parse('$baseUrl/sessions?courseId=$courseId&facultyCode=$username'),
      );

      if (response.statusCode == 200) {
        final session = SessionModel.fromJson(jsonDecode(response.body));
        return {'success': true, 'session': session};
      } else {
        return jsonDecode(response.body);
      }
    } catch (e, stack) {
      log('Error logging in: $e\n$stack');
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  Future<Map<String, dynamic>> fetchSessionRegister(int sessionId) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$baseUrl/sessions/$sessionId'),
      );

      if (response.statusCode == 200) {
        log('get: sessionRegister/$sessionId successfull');
        final sessionRegister = SessionRegister.fromJson(
          jsonDecode(response.body),
        );
        return {'success': true, 'sessionRegister': sessionRegister};
      }
      return jsonDecode(response.body);
    } catch (e, stack) {
      log('Error logging in: $e\n$stack');
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  Future<Map<String, dynamic>> updateSession(
    SessionRegister sessionRegister,
  ) async {
    try {
      final response = await _httpClient.put(
        Uri.parse('$baseUrl/sessions'),
        body: jsonEncode(sessionRegister.toJson()),
      );

      if (response.statusCode == 204) {
        return {'success': true};
      } else {
        return jsonDecode(response.body);
      }
    } catch (e, stack) {
      log('Error logging in: $e\n$stack');
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }
}
