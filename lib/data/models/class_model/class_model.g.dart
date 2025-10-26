// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassModel _$ClassModelFromJson(Map<String, dynamic> json) => ClassModel(
  courseId: (json['course_id'] as num).toInt(),
  className: json['class_name'] as String,
  subjectName: json['subject_name'] as String,
);

Map<String, dynamic> _$ClassModelToJson(ClassModel instance) =>
    <String, dynamic>{
      'course_id': instance.courseId,
      'class_name': instance.className,
      'subject_name': instance.subjectName,
    };
