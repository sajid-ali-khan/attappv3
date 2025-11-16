// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassModel _$ClassModelFromJson(Map<String, dynamic> json) => ClassModel(
  classId: (json['classId'] as num).toInt(),
  className: json['className'] as String,
  subjectShortForm: json['subjectShortForm'] as String,
  subjectFullForm: json['subjectFullForm'] as String,
);

Map<String, dynamic> _$ClassModelToJson(ClassModel instance) =>
    <String, dynamic>{
      'classId': instance.classId,
      'className': instance.className,
      'subjectShortForm': instance.subjectShortForm,
      'subjectFullForm': instance.subjectFullForm,
    };
