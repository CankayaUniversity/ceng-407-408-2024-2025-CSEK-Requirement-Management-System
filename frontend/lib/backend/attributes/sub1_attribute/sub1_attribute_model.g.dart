// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub1_attribute_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sub1AttributeModel _$Sub1AttributeModelFromJson(Map<String, dynamic> json) =>
    Sub1AttributeModel(
      id: json['id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      subsystem1Id: json['subsystem1Id'] as String,
    );

Map<String, dynamic> _$Sub1AttributeModelToJson(Sub1AttributeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subsystem1Id': instance.subsystem1Id,
      'description': instance.description,
    };
