import 'package:json_annotation/json_annotation.dart';

part 'user_attribute_model.g.dart';

@JsonSerializable()
class UserAttributeModel {
  final String header;
  final String userRequirementId;
  final String description;

  UserAttributeModel({
    required this.header,
    required this.description,
    required this.userRequirementId

  });

  factory UserAttributeModel.fromJson(Map<String, dynamic> json) {
    return UserAttributeModel(
      header: json['header'] ?? '',
      userRequirementId: json['userRequirementId'],
      description: json['description']
    );
  }
  Map<String, dynamic> toJson() => _$UserAttributeModelToJson(this);
}