import 'package:json_annotation/json_annotation.dart';

part 'sub3_attribute_model.g.dart';

@JsonSerializable()
class Sub3AttributeModel {
  final String? id;
  final String title;
  final String subsystem3Id;
  final String description;

  Sub3AttributeModel({
    this.id,
    required this.title,
    required this.description,
    required this.subsystem3Id,
  });

  factory Sub3AttributeModel.fromJson(Map<String, dynamic> json) {
    return Sub3AttributeModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subsystem3Id: json['subsystem3Id'],
      description: json['description'],
    );
  }
  Map<String, dynamic> toJson() => _$Sub3AttributeModelToJson(this);
}
