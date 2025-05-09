import 'package:json_annotation/json_annotation.dart';

part 'header_sub2req_model.g.dart';

@JsonSerializable()
class Header_Sub2Req_Model {
  final String header;

  Header_Sub2Req_Model({
    required this.header,

  });

  factory Header_Sub2Req_Model.fromJson(Map<String, dynamic> json) {
    return Header_Sub2Req_Model(
        header: json['header'] ?? '',

    );
  }
  Map<String, dynamic> toJson() => _$Header_Sub2Req_ModelToJson(this);
}