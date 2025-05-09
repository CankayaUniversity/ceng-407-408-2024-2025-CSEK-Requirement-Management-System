import 'package:json_annotation/json_annotation.dart';

part 'changeLog_system_requirement_model.g.dart';

@JsonSerializable()
class SystemRequirementChangeLog {
  final String? id;
  final String? modifiedBy;
  final String? oldTitle;
  final String? oldDescription;
  final String? requirementId;
  final List<String>? header;
  final List<String>? oldAttributeDescription;
  final String? changeType;
  final DateTime? modifiedAt;

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