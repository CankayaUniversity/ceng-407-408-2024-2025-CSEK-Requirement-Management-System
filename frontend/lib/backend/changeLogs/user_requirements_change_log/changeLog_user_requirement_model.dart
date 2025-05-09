import 'package:json_annotation/json_annotation.dart';

part 'changeLog_user_requirement_model.g.dart';

@JsonSerializable()
class UserRequirementChangeLog {
  final String? id;
  final String? modifiedBy;
  final String? oldTitle;
  final String? oldDescription;
  final String? requirementId;
  final List<String>? header;
  final List<String>? oldAttributeDescription;
  final String? changeType;
  final DateTime? modifiedAt;

  UserRequirementChangeLog({
    this.id,
    this.modifiedBy,
    this.oldTitle,
    this.oldDescription,
    this.requirementId,
    this.header,
    this.oldAttributeDescription,
    this.changeType,
    this.modifiedAt,
  });

  factory UserRequirementChangeLog.fromJson(Map<String, dynamic> json) =>
      _$UserRequirementChangeLogFromJson(json);

  Map<String, dynamic> toJson() => _$UserRequirementChangeLogToJson(this);
}