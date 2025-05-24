// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_requirement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemReqModel _$SystemReqModelFromJson(Map<String, dynamic> json) =>
    SystemReqModel(
      title: json['title'] as String,
      description: json['description'] as String,
      id: json['id'] as String,
      createdBy: json['createdBy'] as String,
      user_req_id: json['user_req_id'] as String,
      flag: json['flag'] as bool,
      projectId: json['projectId'] as String,
    );

Map<String, dynamic> _$SystemReqModelToJson(SystemReqModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'id': instance.id,
      'createdBy': instance.createdBy,
      'user_req_id': instance.user_req_id,
      'flag': instance.flag,
      'projectId': instance.projectId,
    };
