// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentAttendance _$StudentAttendanceFromJson(Map<String, dynamic> json) =>
    StudentAttendance(
      roll: json['roll'] as String,
      name: json['name'] as String,
      presentDays: (json['presentDays'] as num).toInt(),
      totalDays: (json['totalDays'] as num).toInt(),
      attendancePercentage: (json['attendancePercentage'] as num).toDouble(),
    );

Map<String, dynamic> _$StudentAttendanceToJson(StudentAttendance instance) =>
    <String, dynamic>{
      'roll': instance.roll,
      'name': instance.name,
      'presentDays': instance.presentDays,
      'totalDays': instance.totalDays,
      'attendancePercentage': instance.attendancePercentage,
    };
