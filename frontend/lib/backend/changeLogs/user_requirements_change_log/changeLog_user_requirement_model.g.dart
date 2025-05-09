// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'changeLog_user_requirement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRequirementChangeLog _$UserRequirementChangeLogFromJson(
  Map<String, dynamic> json,
) => UserRequirementChangeLog(
  id: json['id'] as String?,
  modifiedBy: json['modifiedBy'] as String?,
  oldTitle: json['oldTitle'] as String?,
  oldDescription: json['oldDescription'] as String?,
  requirementId: json['requirementId'] as String?,
  header: (json['header'] as List<dynamic>?)?.map((e) => e as String).toList(),
  oldAttributeDescription:
      (json['oldAttributeDescription'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
  changeType: json['changeType'] as String?,
  modifiedAt:
      json['modifiedAt'] == null
          ? null
          : DateTime.parse(json['modifiedAt'] as String),
);

Map<String, dynamic> _$UserRequirementChangeLogToJson(
  UserRequirementChangeLog instance,
) => <String, dynamic>{
  'id': instance.id,
  'modifiedBy': instance.modifiedBy,
  'oldTitle': instance.oldTitle,
  'oldDescription': instance.oldDescription,
  'requirementId': instance.requirementId,
  'header': instance.header,
  'oldAttributeDescription': instance.oldAttributeDescription,
  'changeType': instance.changeType,
  'modifiedAt': instance.modifiedAt?.toIso8601String(),
};
