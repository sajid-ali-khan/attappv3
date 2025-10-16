import 'package:attappv1/data/models/assigned_class.dart';
import 'package:attappv1/data/models/report_row.dart';
import 'package:attappv1/data/models/session.dart';
import 'package:attappv1/data/models/student.dart';

class Constants {
	static var assignedClasses = [
		AssignedClass("Theory of Computation", "2nd Sem CSE"),
		AssignedClass("Artificial Intelligence", "4th Sem CSE"),
		AssignedClass("Object Oriented Design and Principles", "6th Sem CSE"),
	];

  static var sessions = [
    Session(1, DateTime.now()),
    Session(2, DateTime.now())
  ];

  static List<Student> students = [
    Student("sajid", "229x1a2851"),
    Student("theja", "229x1a2842"),
    Student("musa", "229x1a2870"),
    Student("praveen", "229x1a2845"),
    Student("raghu", "229x1a2861"),
    Student("charan", "229x1a2862"),
    Student("uma mahesh", "229x1a2850"),
    Student("harsha", "229x1a2852"),
    Student("sreeram", "229x1a2844"),
    Student("navneeth", "229x1a2846"),
    Student("vijay", "229x1a2841"),
  ];

  static var report = students.map((s){
    return ReportRow(s, 89.0);
  }).toList();
}