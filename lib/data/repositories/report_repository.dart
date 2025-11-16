import 'dart:convert';
import 'dart:developer';

import 'package:attappv1/data/constants.dart';
import 'package:attappv1/data/models/attendance_report/attendance_report.dart';
import 'package:attappv1/data/network/auth_http_client.dart';

class ReportRepository {
  final _httpClient = AuthHttpClient();

  Future<Map<String, dynamic>> fetchClassAttendanceReport(
    int branchCode,
    int semester,
    String section,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    var apiUrl =
        '$baseUrl/student-batches/report/consolidated?branchCode=$branchCode&semester=$semester&section=$section';

    if (startDate != null && endDate != null) {
      final formattedStartDate = startDate.toIso8601String().split('T')[0];
      final formattedEndDate = endDate.toIso8601String().split('T')[0];
      log('startDate: $formattedStartDate, endDate: $formattedEndDate');
      apiUrl += '&startDate=$formattedStartDate&endDate=$formattedEndDate';
    }
    try {
      final uri = Uri.parse(apiUrl);
      final response = await _httpClient.get(uri);

      if (response.statusCode == 200) {
        log('fetched attendance report for $branchCode-$semester-$section');
        final attendanceReport = AttendanceReport.fromJson(
          jsonDecode(response.body),
        );
        return {'success': true, 'attendanceReport': attendanceReport};
      } else {
        log('Something went wrong, ${response.statusCode}: ${response.body}');
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e, stack) {
      log('Error logging in: $e\n$stack');
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }

  Future<Map<String, dynamic>> fetchSubjectAttendanceReport(
    int courseId,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    String apiUrl = '$baseUrl/courses/$courseId/attendanceReport';

    if (startDate != null && endDate != null) {
      final formattedStartDate = startDate.toIso8601String().split('T')[0];
      final formattedEndDate = endDate.toIso8601String().split('T')[0];

      log('Without formatting -> startDate: $startDate, endDate: $endDate');
      log('startDate: $formattedStartDate, endDate: $formattedEndDate');
      apiUrl += '?startDate=$formattedStartDate&endDate=$formattedEndDate';
    }

    try {
      final response = await _httpClient.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        log('fetched attendance report for course(ID: $courseId)');
        final attendanceReport = AttendanceReport.fromJson(
          jsonDecode(response.body),
        );
        return {'success': true, 'attendanceReport': attendanceReport};
      } else {
        log('Something went wrong, ${response.statusCode}: ${response.body}');
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e, stack) {
      log('Error logging in: $e\n$stack');
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }
}
