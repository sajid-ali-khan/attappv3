// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jwt_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JwtResponse _$JwtResponseFromJson(Map<String, dynamic> json) => JwtResponse(
  token: json['token'] as String,
  type: json['type'] as String,
  username: json['username'] as String,
  role: json['role'] as String,
);

Map<String, dynamic> _$JwtResponseToJson(JwtResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
      'type': instance.type,
      'username': instance.username,
      'role': instance.role,
    };
