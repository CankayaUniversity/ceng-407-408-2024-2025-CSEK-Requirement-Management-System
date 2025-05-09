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

  SystemReqModel({
    required this.title,
    required this.description,
    required this.id,
    required this.createdBy,
    required this.user_req_id,
    required this.flag,
  });

  factory SystemReqModel.fromJson(Map<String, dynamic> json) {
    return SystemReqModel(
      title: json['title'],
      description: json['description'] ?? '',
      id: json['id'],
      createdBy: json['createdBy'],
      user_req_id: json['user_req_id'],
      flag: json['flag'],
    );
  }
  Map<String, dynamic> toJson() => _$SystemReqModelToJson(this);
}