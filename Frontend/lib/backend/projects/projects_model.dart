import 'package:json_annotation/json_annotation.dart';

part 'projects_model.g.dart';

@JsonSerializable()
class ProjectsModel {
  final String id;
  final String name;

  ProjectsModel({required this.id, required this.name});

  factory ProjectsModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectsModelToJson(this);
}
