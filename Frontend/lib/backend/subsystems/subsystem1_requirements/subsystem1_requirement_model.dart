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
  final String projectId;

  Subsystem1ReqModel({
    required this.title,
    required this.description,
    required this.id,
    required this.createdBy,
    required this.systemRequirementId,
    required this.flag,
    required this.projectId,
  });

  factory Subsystem1ReqModel.fromJson(Map<String, dynamic> json) =>
      _$Subsystem1ReqModelFromJson(json);

  Map<String, dynamic> toJson() => _$Subsystem1ReqModelToJson(this);

  Subsystem1ReqModel copyWith({
    String? title,
    String? description,
    String? id,
    String? createdBy,
    String? systemRequirementId,
    bool? flag,
  }) {
    return Subsystem1ReqModel(
      title: title ?? this.title,
      description: description ?? this.description,
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      systemRequirementId: systemRequirementId ?? this.systemRequirementId,
      flag: flag ?? this.flag,
      projectId: projectId ?? this.projectId,
    );
  }

  factory Subsystem1ReqModel.empty() {
    return Subsystem1ReqModel(
      title: '',
      description: '',
      id: '',
      createdBy: '',
      systemRequirementId: '',
      flag: false,
      projectId: '',
    );
  }
}
