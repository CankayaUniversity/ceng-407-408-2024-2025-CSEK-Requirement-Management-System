import 'package:json_annotation/json_annotation.dart';

part 'system_attribute_model.g.dart';

@JsonSerializable()
class SystemAttributeModel {
  final String header;
  final String systemRequirementId;
  final String description;

  SystemAttributeModel({
    required this.header,
    required this.description,
    required this.systemRequirementId

  });

  factory SystemAttributeModel.fromJson(Map<String, dynamic> json) {
    return SystemAttributeModel(
      header: json['header'] ?? '',
        systemRequirementId: json['systemRequirementId'],
      description: json['description']
    );
  }
  Map<String, dynamic> toJson() => _$SystemAttributeModelToJson(this);
}