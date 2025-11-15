
import 'package:json_annotation/json_annotation.dart';

part 'branch_model.g.dart';

@JsonSerializable()
class BranchModel {
  String shortForm;
  String fullForm;
  int branchCode;

  String get displayName => '$shortForm - $fullForm';

  BranchModel({
    required this.shortForm,
    required this.fullForm,
    required this.branchCode,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) => _$BranchModelFromJson(json);
  Map<String, dynamic> toJson() => _$BranchModelToJson(this);
}