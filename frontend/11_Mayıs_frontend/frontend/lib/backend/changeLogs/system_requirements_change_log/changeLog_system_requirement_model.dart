import 'package:frontend/backend/changeLogs/changeLog_requirement_interface_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'changeLog_system_requirement_model.g.dart';

@JsonSerializable()
class SystemRequirementChangeLog implements RequirementChangeLog{
  @override final String? id;
  @override final String? modifiedBy;
  @override final String? oldTitle;
  @override final String? oldDescription;
  @override final String? requirementId;
  @override final List<String>? header;
  @override final List<String>? oldAttributeDescription;
  @override final String? changeType;
  @override final DateTime? modifiedAt;

  SystemRequirementChangeLog({
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

  factory SystemRequirementChangeLog.fromJson(Map<String, dynamic> json) =>
      _$SystemRequirementChangeLogFromJson(json);

  Map<String, dynamic> toJson() => _$SystemRequirementChangeLogToJson(this);
}