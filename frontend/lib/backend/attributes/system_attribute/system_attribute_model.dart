import 'package:json_annotation/json_annotation.dart';

part 'system_attribute_model.g.dart';

@JsonSerializable()
class SystemAttributeModel {
  final String? id;
  final String header;
  final String systemRequirementId;
  final String description;

  SystemAttributeModel({
    this.id,
    required this.header,
    required this.description,
    required this.systemRequirementId

  });

  factory SystemAttributeModel.fromJson(Map<String, dynamic> json) {
    return SystemAttributeModel(
        id: json['id'] ?? '',
      header: json['header'] ?? '',
        systemRequirementId: json['systemRequirementId'],
      description: json['description']
    );
  }
  Map<String, dynamic> toJson() => _$SystemAttributeModelToJson(this);
}