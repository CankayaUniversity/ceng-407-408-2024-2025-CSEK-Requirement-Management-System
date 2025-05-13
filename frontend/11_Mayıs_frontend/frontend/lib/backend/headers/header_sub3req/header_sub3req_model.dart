import 'package:json_annotation/json_annotation.dart';

part 'header_sub3req_model.g.dart';

@JsonSerializable()
class Header_Sub3Req_Model {
  final String header;

  Header_Sub3Req_Model({
    required this.header,

  });

  factory Header_Sub3Req_Model.fromJson(Map<String, dynamic> json) {
    return Header_Sub3Req_Model(
        header: json['header'] ?? '',

    );
  }
  Map<String, dynamic> toJson() => _$Header_Sub3Req_ModelToJson(this);
}