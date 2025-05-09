import 'package:json_annotation/json_annotation.dart';

part 'changeLog_subsystem1_requirement_model.g.dart';

@JsonSerializable()
class Subsystem1RequirementChangeLog {
  final String? id;
  final String? modifiedBy;
  final String? oldTitle;
  final String? oldDescription;
  final String? requirementId;
  final List<String>? header;
  final List<String>? oldAttributeDescription;
  final String? changeType;
  final DateTime? modifiedAt;

  Subsystem1RequirementChangeLog({
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

  factory Subsystem1RequirementChangeLog.fromJson(Map<String, dynamic> json) =>
      _$Subsystem1RequirementChangeLogFromJson(json);

  Map<String, dynamic> toJson() => _$Subsystem1RequirementChangeLogToJson(this);
}