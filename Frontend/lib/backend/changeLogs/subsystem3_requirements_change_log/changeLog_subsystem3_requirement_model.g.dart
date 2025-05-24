// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'changeLog_subsystem3_requirement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subsystem3RequirementChangeLog _$Subsystem3RequirementChangeLogFromJson(
  Map<String, dynamic> json,
) => Subsystem3RequirementChangeLog(
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
  projectId: json['projectId'] as String,
);

Map<String, dynamic> _$Subsystem3RequirementChangeLogToJson(
  Subsystem3RequirementChangeLog instance,
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
  'projectId': instance.projectId,
};
