import 'package:json_annotation/json_annotation.dart';

part 'changeLog_subsystem3_requirement_model.g.dart';

@JsonSerializable()
class Subsystem3RequirementChangeLog {
  final String? id;
  final String? modifiedBy;
  final String? oldTitle;
  final String? oldDescription;
  final String? requirementId;
  final List<String>? header;
  final List<String>? oldAttributeDescription;
  final String? changeType;
  final DateTime? modifiedAt;

  Subsystem3RequirementChangeLog({
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

  factory Subsystem3RequirementChangeLog.fromJson(Map<String, dynamic> json) =>
      _$Subsystem3RequirementChangeLogFromJson(json);

  Map<String, dynamic> toJson() => _$Subsystem3RequirementChangeLogToJson(this);
}