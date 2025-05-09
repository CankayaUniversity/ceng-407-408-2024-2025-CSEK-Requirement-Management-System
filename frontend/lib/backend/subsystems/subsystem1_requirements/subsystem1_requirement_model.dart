import 'package:json_annotation/json_annotation.dart';

part 'subsystem1_requirement_model.g.dart';

@JsonSerializable()
class Subsystem1ReqModel {
  final String title;
  final String description;
  final String id;
  final String createdBy;
  final String systemRequirementId;
  final bool flag;

  Subsystem1ReqModel({
    required this.title,
    required this.description,
    required this.id,
    required this.createdBy,
    required this.systemRequirementId,
    required this.flag,
  });

  factory Subsystem1ReqModel.fromJson(Map<String, dynamic> json) =>
      _$Subsystem1ReqModelFromJson(json);

  Map<String, dynamic> toJson() => _$Subsystem1ReqModelToJson(this);
}