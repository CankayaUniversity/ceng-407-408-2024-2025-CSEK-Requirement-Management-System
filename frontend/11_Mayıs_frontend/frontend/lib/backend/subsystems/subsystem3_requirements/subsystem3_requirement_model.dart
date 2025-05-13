import 'package:json_annotation/json_annotation.dart';

part 'subsystem3_requirement_model.g.dart';

@JsonSerializable()
class Subsystem3ReqModel {
  final String title;
  final String description;
  final String id;
  final String createdBy;
  final String systemRequirementId;
  final bool flag;

  Subsystem3ReqModel({
    required this.title,
    required this.description,
    required this.id,
    required this.createdBy,
    required this.systemRequirementId,
    required this.flag,
  });

  factory Subsystem3ReqModel.fromJson(Map<String, dynamic> json) =>
      _$Subsystem3ReqModelFromJson(json);

  Map<String, dynamic> toJson() => _$Subsystem3ReqModelToJson(this);
}