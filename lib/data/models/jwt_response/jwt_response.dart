
import 'package:json_annotation/json_annotation.dart';

part 'jwt_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class JwtResponse {
  String token;
  String type;
  String username;
  String role;

  JwtResponse({
    required this.token,
    required this.type,
    required this.username,
    required this.role,
  });

  factory JwtResponse.fromJson(Map<String, dynamic> json) => _$JwtResponseFromJson(json);

  Map<String, dynamic> toJson() => _$JwtResponseToJson(this);
}
