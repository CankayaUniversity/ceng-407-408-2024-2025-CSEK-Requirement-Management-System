import 'package:json_annotation/json_annotation.dart';

part 'sub1_attribute_model.g.dart';

@JsonSerializable()
class Sub1AttributeModel {
  final String title;
  final String subsystem1Id;
  final String description;

  Sub1AttributeModel({
    required this.title,
    required this.description,
    required this.subsystem1Id

  });

  factory Sub1AttributeModel.fromJson(Map<String, dynamic> json) {
    return Sub1AttributeModel(
        title: json['title'] ?? '',
        subsystem1Id: json['subsystem1Id'],
      description: json['description']
    );
  }
  Map<String, dynamic> toJson() => _$Sub1AttributeModelToJson(this);
}