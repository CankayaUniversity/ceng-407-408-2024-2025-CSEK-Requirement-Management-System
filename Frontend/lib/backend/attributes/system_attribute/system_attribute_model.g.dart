// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_attribute_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemAttributeModel _$SystemAttributeModelFromJson(
  Map<String, dynamic> json,
) => SystemAttributeModel(
  id: json['id'] as String?,
  header: json['header'] as String,
  description: json['description'] as String,
  systemRequirementId: json['systemRequirementId'] as String,
);

Map<String, dynamic> _$SystemAttributeModelToJson(
  SystemAttributeModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'header': instance.header,
  'systemRequirementId': instance.systemRequirementId,
  'description': instance.description,
};
