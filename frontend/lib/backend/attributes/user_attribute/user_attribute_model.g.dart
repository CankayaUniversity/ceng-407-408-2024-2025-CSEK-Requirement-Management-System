// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_attribute_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAttributeModel _$UserAttributeModelFromJson(Map<String, dynamic> json) =>
    UserAttributeModel(
      header: json['header'] as String,
      description: json['description'] as String,
      userRequirementId: json['userRequirementId'] as String,
    );

Map<String, dynamic> _$UserAttributeModelToJson(UserAttributeModel instance) =>
    <String, dynamic>{
      'header': instance.header,
      'userRequirementId': instance.userRequirementId,
      'description': instance.description,
    };
