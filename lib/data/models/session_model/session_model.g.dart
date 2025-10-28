// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionModel _$SessionModelFromJson(Map<String, dynamic> json) => SessionModel(
  sessionId: (json['sessionId'] as num).toInt(),
  sessionName: json['sessionName'] as String,
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$SessionModelToJson(SessionModel instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'sessionName': instance.sessionName,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
