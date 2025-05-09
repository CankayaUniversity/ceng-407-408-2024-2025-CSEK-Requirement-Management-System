// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subsystem1_requirement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subsystem1ReqModel _$Subsystem1ReqModelFromJson(Map<String, dynamic> json) =>
    Subsystem1ReqModel(
      title: json['title'] as String,
      description: json['description'] as String,
      id: json['id'] as String,
      createdBy: json['createdBy'] as String,
      systemRequirementId: json['systemRequirementId'] as String,
      flag: json['flag'] as bool,
    );

Map<String, dynamic> _$Subsystem1ReqModelToJson(Subsystem1ReqModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'id': instance.id,
      'createdBy': instance.createdBy,
      'systemRequirementId': instance.systemRequirementId,
      'flag': instance.flag,
    };
