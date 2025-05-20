import 'package:json_annotation/json_annotation.dart';

part 'system_requirement_model.g.dart';

@JsonSerializable()
class SystemReqModel {
  final String title;
  final String description;
  final String id;
  final String createdBy;
  final String user_req_id;
  final bool flag;
  final String projectId;

  SystemReqModel({
    required this.title,
    required this.description,
    required this.id,
    required this.createdBy,
    required this.user_req_id,
    required this.flag,
    required this.projectId,
  });

  factory SystemReqModel.fromJson(Map<String, dynamic> json) =>
      _$SystemReqModelFromJson(json);

  Map<String, dynamic> toJson() => _$SystemReqModelToJson(this);
}
