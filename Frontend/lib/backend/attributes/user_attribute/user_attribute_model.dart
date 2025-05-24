import 'package:json_annotation/json_annotation.dart';

part 'user_attribute_model.g.dart';

@JsonSerializable()
class UserAttributeModel {
  final String? id;
  final String header;
  final String userRequirementId;
  final String description;

  UserAttributeModel({
    this.id,
    required this.header,
    required this.description,
    required this.userRequirementId,
  });

  factory UserAttributeModel.fromJson(Map<String, dynamic> json) =>
      _$UserAttributeModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserAttributeModelToJson(this);
}