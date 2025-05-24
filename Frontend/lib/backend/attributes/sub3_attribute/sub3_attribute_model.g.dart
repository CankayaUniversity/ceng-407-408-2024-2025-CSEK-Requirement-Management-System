// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub3_attribute_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sub3AttributeModel _$Sub3AttributeModelFromJson(Map<String, dynamic> json) =>
    Sub3AttributeModel(
      id: json['id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      subsystem3Id: json['subsystem3Id'] as String,
    );

Map<String, dynamic> _$Sub3AttributeModelToJson(Sub3AttributeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subsystem3Id': instance.subsystem3Id,
      'description': instance.description,
    };
