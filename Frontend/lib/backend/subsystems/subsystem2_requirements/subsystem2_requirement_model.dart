import 'package:json_annotation/json_annotation.dart';

part 'subsystem2_requirement_model.g.dart';

@JsonSerializable()
class Subsystem2ReqModel {
  final String title;
  final String description;
  final String id;
  final String createdBy;
  final String systemRequirementId;
  final bool flag;
  final String projectId;

  Subsystem2ReqModel({
    required this.title,
    required this.description,
    required this.id,
    required this.createdBy,
    required this.systemRequirementId,
    required this.flag,
    required this.projectId,
  });

  factory Subsystem2ReqModel.fromJson(Map<String, dynamic> json) =>
      _$Subsystem2ReqModelFromJson(json);

  Map<String, dynamic> toJson() => _$Subsystem2ReqModelToJson(this);
}
