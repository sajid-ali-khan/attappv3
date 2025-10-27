// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassModel _$ClassModelFromJson(Map<String, dynamic> json) => ClassModel(
  classId: (json['classId'] as num).toInt(),
  className: json['className'] as String,
  subjectName: json['subjectName'] as String,
);

Map<String, dynamic> _$ClassModelToJson(ClassModel instance) =>
    <String, dynamic>{
      'classId': instance.classId,
      'className': instance.className,
      'subjectName': instance.subjectName,
    };
