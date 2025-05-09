import 'package:json_annotation/json_annotation.dart';

part 'sub2_attribute_model.g.dart';

@JsonSerializable()
class Sub2AttributeModel {
  final String title;
  final String subsystem2Id;
  final String description;

  Sub2AttributeModel({
    required this.title,
    required this.description,
    required this.subsystem2Id

  });

  factory Sub2AttributeModel.fromJson(Map<String, dynamic> json) {
    return Sub2AttributeModel(
        title: json['title'] ?? '',
        subsystem2Id: json['subsystem2Id'],
      description: json['description']
    );
  }
  Map<String, dynamic> toJson() => _$Sub2AttributeModelToJson(this);
}