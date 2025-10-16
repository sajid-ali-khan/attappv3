import 'package:attappv1/data/models/student_model.dart';

class ReportRow {
  StudentModel student;
  double percentage;

  ReportRow({required this.student, required this.percentage});

  factory ReportRow.fromJson(Map<String, dynamic> json){
    return ReportRow(student: json['student'], percentage: json['percentage']);
  }
}