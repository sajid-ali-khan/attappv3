
import 'package:json_annotation/json_annotation.dart';

part 'student_attendance.g.dart';

@JsonSerializable()
class StudentAttendance {
  String roll;
  String name;
  int presentDays;
  int totalDays;
  double attendancePercentage;

  StudentAttendance({
    required this.roll,
    required this.name,
    required this.presentDays,
    required this.totalDays,
    required this.attendancePercentage,
  });


  factory StudentAttendance.fromJson(Map<String, dynamic> json) => _$StudentAttendanceFromJson(json);
}