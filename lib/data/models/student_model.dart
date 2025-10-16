class StudentModel {
  String roll;
  String name;

  StudentModel({required this.roll, required this.name});

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(roll: json['roll'], name: json['name']);
  }
}
