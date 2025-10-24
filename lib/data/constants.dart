import 'package:attappv1/data/models/attendance_row.dart';
import 'package:attappv1/data/models/class_model.dart';
import 'package:attappv1/data/models/report_row.dart';
import 'package:attappv1/data/models/session_model.dart';
import 'package:attappv1/data/models/student_model.dart';

class Constants {
	static List<ClassModel> classes = [
		ClassModel(subjectName: "Theory of Computation", className:  "2nd Sem CSE", courseId: 0),
		ClassModel(subjectName: "Artificial Intelligence", className:  "4th Sem CSE", courseId: 0),
		ClassModel(subjectName: "Object Oriented Design and Principles", className:  "6th Sem CSE", courseId: 0),
	];

  static List<SessionModel> sessions = [
    SessionModel(sessionId: 0, sessionName: 'Session 1', updatedAt: DateTime.now()),
    SessionModel(sessionId: 0, sessionName: 'Session 2', updatedAt: DateTime.now()),
  ];

  static List<StudentModel> students = [
    StudentModel(name: "Patan Sajid Ali Khan", roll: "229x1a2851"),
    StudentModel(name: "theja", roll: "229x1a2842"),
    StudentModel(name: "musa", roll: "229x1a2870"),
    StudentModel(name: "praveen", roll: "229x1a2845"),
    StudentModel(name: "raghu", roll: "229x1a2861"),
    StudentModel(name: "charan", roll: "229x1a2862"),
    StudentModel(name: "uma mahesh", roll: "229x1a2850"),
    StudentModel(name: "harsha", roll: "229x1a2852"),
    StudentModel(name: "Ghadiyaram Jaya Sai Sreerama Kumar", roll: "229x1a2844"),
    StudentModel(name: "navneeth", roll: "229x1a2846"),
    StudentModel(name: "vijay", roll: "229x1a2841"),
  ];

  static List<AttendanceRow> attendanceList = students.map((s){
    return AttendanceRow(student: s);
  }).toList();

  static var report = students.map((s){
    return ReportRow(student: s, percentage: 89.0);
  }).toList();
}