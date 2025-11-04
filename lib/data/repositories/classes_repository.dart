import 'dart:convert';
import 'dart:developer';

import 'package:attappv1/data/constants.dart';
import 'package:attappv1/data/models/class_model/class_model.dart';
import 'package:attappv1/data/network/auth_http_client.dart';
import 'package:attappv1/data/services/shared_prefs_service.dart';

class ClassesRepository {
  final AuthHttpClient _httpClient = AuthHttpClient();

  Future<Map<String, dynamic>> getFacultyClasses() async {
    String? userId = await getUsername();
    if (userId == null) return {'success': false, 'message': 'Couldn\'t fetch userId'};

    try {
      final response = await _httpClient.get(
        Uri.parse('$baseUrl/faculties/$userId/classes'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List;
        log(json.toString());
        final List<ClassModel> classes = [];
        for (var c in json) {
          classes.add(ClassModel.fromJson(c));
        }
        return {'success': true, 'classes': classes};
      }else {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e, stack) {
      log('Error logging in: $e\n$stack');
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }
}
