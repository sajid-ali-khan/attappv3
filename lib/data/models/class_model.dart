class ClassModel {
  int courseId;
  String className;
  String subjectName;

  ClassModel({
    required this.courseId,
    required this.className,
    required this.subjectName,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      className: json['className'],
      courseId: 0,
      subjectName: json['subjectName'],
    );
  }
}
