// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_requirement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserReqModel _$UserReqModelFromJson(Map<String, dynamic> json) => UserReqModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  createdBy: json['createdBy'] as String,
  flag: json['flag'] as bool,
);

Map<String, dynamic> _$UserReqModelToJson(UserReqModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'flag': instance.flag,
      'createdBy': instance.createdBy,
    };
