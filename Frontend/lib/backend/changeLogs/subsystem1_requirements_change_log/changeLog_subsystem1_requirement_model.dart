import 'package:frontend/backend/changeLogs/changeLog_requirement_interface_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'changeLog_subsystem1_requirement_model.g.dart';

@JsonSerializable()
class Subsystem1RequirementChangeLog implements RequirementChangeLog {
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
    required this.projectId,
  });

  factory Subsystem1RequirementChangeLog.fromJson(Map<String, dynamic> json) =>
      _$Subsystem1RequirementChangeLogFromJson(json);

  Map<String, dynamic> toJson() => _$Subsystem1RequirementChangeLogToJson(this);
}
