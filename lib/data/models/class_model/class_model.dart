import 'package:json_annotation/json_annotation.dart';

part 'class_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ClassModel {
  int courseId;
  String className;
  String subjectName;

  ClassModel({
    required this.courseId,
    required this.className,
    required this.subjectName,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) => _$ClassModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClassModelToJson(this);
}
