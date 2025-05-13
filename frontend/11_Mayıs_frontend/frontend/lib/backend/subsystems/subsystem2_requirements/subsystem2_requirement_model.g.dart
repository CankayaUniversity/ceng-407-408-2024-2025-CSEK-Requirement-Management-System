// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subsystem2_requirement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subsystem2ReqModel _$Subsystem2ReqModelFromJson(Map<String, dynamic> json) =>
    Subsystem2ReqModel(
      title: json['title'] as String,
      description: json['description'] as String,
      id: json['id'] as String,
      createdBy: json['createdBy'] as String,
      systemRequirementId: json['systemRequirementId'] as String,
      flag: json['flag'] as bool,
    );

Map<String, dynamic> _$Subsystem2ReqModelToJson(Subsystem2ReqModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'id': instance.id,
      'createdBy': instance.createdBy,
      'systemRequirementId': instance.systemRequirementId,
      'flag': instance.flag,
    };
