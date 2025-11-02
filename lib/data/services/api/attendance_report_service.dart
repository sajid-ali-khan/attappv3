import 'dart:convert';
import 'dart:developer';

import 'package:attappv1/data/constants.dart';
import 'package:attappv1/data/models/attendance_report/attendance_report.dart';
import 'package:attappv1/data/network/auth_http_client.dart';

final khttp = AuthHttpClient();

Future<AttendanceReport> fetchFullAttendanceReport(int courseId) async{
  final uri = Uri.parse('$baseUrl/courses/$courseId/attendanceReport');

  return await _fetchAttendanceReport(uri, courseId);
}

Future<AttendanceReport> fetchFullAttendanceReportBetweenDates(int courseId, DateTime startDate, DateTime endDate) async{
  final startDateString = startDate.toIso8601String().split('T')[0];
  final endDateString = endDate.toIso8601String().split('T')[0];
  final uri = Uri.parse('$baseUrl/courses/$courseId/attendanceReport?startDate=$startDateString&endDate=$endDateString');

  return await _fetchAttendanceReport(uri, courseId);
}

Future<AttendanceReport> _fetchAttendanceReport(Uri uri, int courseId) async{
  final response = await khttp.get(uri);

  if (response.statusCode == 200){
    log('fetched attendance report for course(ID: $courseId)');
    return AttendanceReport.fromJson(jsonDecode(response.body));
  }else {
    log('Something went wrong, ${response.statusCode}: ${response.body}');
    throw Exception("Couldn't fetch attendance report");
  }
}