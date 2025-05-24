import 'package:frontend/backend/changeLogs/changeLog_requirement_interface_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'changeLog_subsystem2_requirement_model.g.dart';

@JsonSerializable()
class Subsystem2RequirementChangeLog implements RequirementChangeLog {
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

  Subsystem2RequirementChangeLog({
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

  factory Subsystem2RequirementChangeLog.fromJson(Map<String, dynamic> json) =>
      _$Subsystem2RequirementChangeLogFromJson(json);

  Map<String, dynamic> toJson() => _$Subsystem2RequirementChangeLogToJson(this);
}
