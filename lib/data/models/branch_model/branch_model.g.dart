// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BranchModel _$BranchModelFromJson(Map<String, dynamic> json) => BranchModel(
  shortForm: json['shortForm'] as String,
  fullForm: json['fullForm'] as String,
  branchCode: json['branchCode'] as int,
);

Map<String, dynamic> _$BranchModelToJson(BranchModel instance) =>
    <String, dynamic>{
      'shortForm': instance.shortForm,
      'fullForm': instance.fullForm,
      'branchCode': instance.branchCode,
    };
