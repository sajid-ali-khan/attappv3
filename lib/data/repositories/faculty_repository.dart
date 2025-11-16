import 'dart:convert';
import 'dart:developer';

import 'package:attappv1/data/constants.dart';
import 'package:attappv1/data/network/auth_http_client.dart';
import 'package:attappv1/data/services/shared_prefs_service.dart';

class FacultyRepository {
  final AuthHttpClient _httpClient = AuthHttpClient();

  Future<Map<String, dynamic>> getFacultyName() async {
    String? username = await getUsername();
    if (username == null) {
      return {'success': false, 'message': 'User not logged in.'};
    }
    final facultyCode = username;

    try {
      final response = await _httpClient.get(
        Uri.parse('$baseUrl/faculties/$facultyCode/name'),
      );

      if (response.statusCode == 404) {
        return {'success': false, 'message': "Username Not Found."};
      }
      final json = jsonDecode(response.body);
      log(json.toString());
      // return json.name;
      return {'success': true, 'name': json["name"]};
    } catch (e) {
      log(e.toString());
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> changePassword(String currentPassword, String newPassword) async {
    String? username = await getUsername();
    if (username == null) {
      return {'success': false, 'message': 'User not logged in.'};
    }
    try {
      final response = await _httpClient.put(
        Uri.parse('$baseUrl/faculties/$username/change-password'),
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 204) {
        return {'success': true};
      } else {
        log('Failed to change password: ${response.body}');
        return {'success': false, 'message': response.body};
      }
    } catch (e) {
      log('Error changing password: ${e.toString()}');
      return {'success': false, 'message': e.toString()};
    }
  }
}
