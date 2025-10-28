// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceRow _$AttendanceRowFromJson(Map<String, dynamic> json) =>
    AttendanceRow(
      id: (json['id'] as num).toInt(),
      roll: json['roll'] as String,
      name: json['name'] as String,
      status: json['status'] as bool,
    );

Map<String, dynamic> _$AttendanceRowToJson(AttendanceRow instance) =>
    <String, dynamic>{
      'id': instance.id,
      'roll': instance.roll,
      'name': instance.name,
      'status': instance.status,
    };
