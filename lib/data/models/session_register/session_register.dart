import 'package:attappv1/data/models/attendance_row/attendance_row.dart';
import 'package:json_annotation/json_annotation.dart';

part 'session_register.g.dart';

@JsonSerializable()
class SessionRegister {
  SessionRegister({
    required this.sessionId,
    required this.sessionName,
    required this.presentCount,
    required this.totalCount,
    required this.updatedAt,
    required this.attendanceRowMap
  });
  int sessionId;
  String sessionName;
  int presentCount;
  int totalCount;
  DateTime updatedAt;
  Map<String, AttendanceRow> attendanceRowMap;

  factory SessionRegister.fromJson(Map<String, dynamic> json) => _$SessionRegisterFromJson(json);

  Map<String, dynamic> toJson() => _$SessionRegisterToJson(this);
}