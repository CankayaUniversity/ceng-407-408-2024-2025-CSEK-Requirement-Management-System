// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub2_attribute_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sub2AttributeModel _$Sub2AttributeModelFromJson(Map<String, dynamic> json) =>
    Sub2AttributeModel(
      id: json['id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      subsystem2Id: json['subsystem2Id'] as String,
    );

Map<String, dynamic> _$Sub2AttributeModelToJson(Sub2AttributeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subsystem2Id': instance.subsystem2Id,
      'description': instance.description,
    };
