import 'package:attappv1/data/services/text_service.dart';
import 'package:json_annotation/json_annotation.dart';

part 'class_model.g.dart';

@JsonSerializable()
class ClassModel {
  int classId;
  String className;
  String subjectShortForm;
  String subjectFullForm;

  String get subjectDisplayName =>
      '$subjectShortForm - ${TextService.toCapitalized(subjectFullForm)}';
  ClassModel({
    required this.classId,
    required this.className,
    required this.subjectShortForm,
    required this.subjectFullForm,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) =>
      _$ClassModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClassModelToJson(this);
}
