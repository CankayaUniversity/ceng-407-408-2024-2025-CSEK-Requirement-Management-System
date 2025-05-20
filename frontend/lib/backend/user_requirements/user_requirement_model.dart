import 'package:json_annotation/json_annotation.dart';

part 'user_requirement_model.g.dart';

@JsonSerializable()
class UserReqModel {
  final String id;
  final String title;
  final String description;
  final bool flag;
  final String createdBy;
  final String projectId;

  UserReqModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.flag,
    required this.projectId,
  });

  factory UserReqModel.fromJson(Map<String, dynamic> json) =>
      _$UserReqModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserReqModelToJson(this);
}
