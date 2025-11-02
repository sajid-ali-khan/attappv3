import 'package:attappv1/data/models/student_attendance/student_attendance.dart';
import 'package:json_annotation/json_annotation.dart';

part 'attendance_report.g.dart';

@JsonSerializable()
class AttendanceReport {
  
  String className;
  String subjectName;
  Map<String, StudentAttendance> studentAttendanceMap;

  AttendanceReport({
    required this.className,
    required this.subjectName,
    required this.studentAttendanceMap
  });

  factory AttendanceReport.fromJson(Map<String, dynamic> json) => _$AttendanceReportFromJson(json);
}