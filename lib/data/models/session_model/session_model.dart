import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'session_model.g.dart';

@JsonSerializable()
class SessionModel {
  int sessionId;
  String sessionName;
  DateTime createdAt;
  DateTime updatedAt;

  SessionModel({
    required this.sessionId,
    required this.createdAt,
    required this.sessionName,
    required this.updatedAt,
  });

  String get updatedAtLocal {
    DateTime localTime = updatedAt.toLocal(); // convert
    final formattedTime = DateFormat.jm().format(localTime);
    final formattedDate = DateFormat.yMMMd().format(localTime);
    return 'Updated at $formattedTime on $formattedDate';
  }

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);
  Map<String, dynamic> toJson() => _$SessionModelToJson(this);
}
