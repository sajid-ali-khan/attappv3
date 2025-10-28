
import 'package:json_annotation/json_annotation.dart';

part 'session_model.g.dart';

@JsonSerializable()
class SessionModel {
  int sessionId;
  String sessionName;
  DateTime updatedAt;

  SessionModel({
    required this.sessionId,
    required this.sessionName,
    required this.updatedAt,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) => _$SessionModelFromJson(json);
  Map<String, dynamic> toJson() => _$SessionModelToJson(this);
}
