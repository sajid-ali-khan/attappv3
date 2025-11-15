import 'dart:convert';
import 'dart:developer';

import 'package:attappv1/data/constants.dart';
import 'package:attappv1/data/models/attendance_report/attendance_report.dart';
import 'package:attappv1/data/network/auth_http_client.dart';

class ReportRepository {
  final _httpClient = AuthHttpClient();

  Future<Map<String, dynamic>> fetchClassAttendanceReport(int branchCode, int semester, String section, DateTime? startDate, DateTime? endDate) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/student-batches/report/consolidated?branchCode=$branchCode&semester=$semester&section=$section&startDate=${startDate?.toIso8601String().split('T')[0]}&endDate=${endDate?.toIso8601String().split('T')[0]}',
      );
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
  
  Future<Map<String, dynamic>> fetchFullAttendanceReport(int courseId) async {
    final uri = Uri.parse('$baseUrl/courses/$courseId/attendanceReport');

    return await _fetchAttendanceReport(uri, courseId);
  }

  Future<Map<String, dynamic>> fetchFullAttendanceReportBetweenDates(
    int courseId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final startDateString = startDate.toIso8601String().split('T')[0];
    final endDateString = endDate.toIso8601String().split('T')[0];
    final uri = Uri.parse(
      '$baseUrl/courses/$courseId/attendanceReport?startDate=$startDateString&endDate=$endDateString',
    );

    return await _fetchAttendanceReport(uri, courseId);
  }

  Future<Map<String, dynamic>> _fetchAttendanceReport(
    Uri uri,
    int courseId,
  ) async {
    try {
      final response = await _httpClient.get(uri);

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
