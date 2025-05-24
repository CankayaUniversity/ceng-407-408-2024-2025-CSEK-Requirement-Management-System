import 'package:json_annotation/json_annotation.dart';
import '../changeLog_requirement_interface_model.dart';

part 'changeLog_user_requirement_model.g.dart';

@JsonSerializable()
class UserRequirementChangeLog implements RequirementChangeLog {
  @override
  final String? id;
  @override
  final String? modifiedBy;
  @override
  final String? oldTitle;
  @override
  final String? oldDescription;
  @override
  final String? requirementId;
  @override
  final List<String>? header;
  @override
  final List<String>? oldAttributeDescription;
  @override
  final String? changeType;
  @override
  final DateTime? modifiedAt;
  @override
  final String projectId;

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
    required this.projectId,
  });

  factory UserRequirementChangeLog.fromJson(Map<String, dynamic> json) =>
      _$UserRequirementChangeLogFromJson(json);

  Map<String, dynamic> toJson() => _$UserRequirementChangeLogToJson(this);
}
