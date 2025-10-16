import 'package:attappv1/data/models/student_model.dart';

class AttendanceRow {
  StudentModel student;
  bool present;

  AttendanceRow({required this.student, this.present = false});

  factory AttendanceRow.fromJson(Map<String, dynamic> json){
    return AttendanceRow(student: json['student']);
  }
}