// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceReport _$AttendanceReportFromJson(Map<String, dynamic> json) =>
    AttendanceReport(
      className: json['className'] as String,
      subjectName: json['subjectName'] as String,
      studentAttendanceMap:
          (json['studentAttendanceMap'] as Map<String, dynamic>).map(
            (k, e) => MapEntry(
              k,
              StudentAttendance.fromJson(e as Map<String, dynamic>),
            ),
          ),
    );

Map<String, dynamic> _$AttendanceReportToJson(AttendanceReport instance) =>
    <String, dynamic>{
      'className': instance.className,
      'subjectName': instance.subjectName,
      'studentAttendanceMap': instance.studentAttendanceMap,
    };
