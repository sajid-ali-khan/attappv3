import 'package:json_annotation/json_annotation.dart';

part 'attendance_row.g.dart';

@JsonSerializable()
class AttendanceRow {
  AttendanceRow({
    required this.id,
    required this.roll,
    required this.name,
    required this.status
  });

  int id;
  String roll;
  String name;
  bool status;

  factory AttendanceRow.fromJson(Map<String, dynamic> json) => _$AttendanceRowFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceRowToJson(this);
}