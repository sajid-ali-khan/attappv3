// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_register.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionRegister _$SessionRegisterFromJson(Map<String, dynamic> json) =>
    SessionRegister(
      sessionId: (json['sessionId'] as num).toInt(),
      sessionName: json['sessionName'] as String,
      presentCount: (json['presentCount'] as num).toInt(),
      totalCount: (json['totalCount'] as num).toInt(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      attendanceRowMap: (json['attendanceRowMap'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, AttendanceRow.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$SessionRegisterToJson(SessionRegister instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'sessionName': instance.sessionName,
      'presentCount': instance.presentCount,
      'totalCount': instance.totalCount,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'attendanceRowMap': instance.attendanceRowMap,
    };
