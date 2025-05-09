import 'package:json_annotation/json_annotation.dart';

part 'header_systemreq_model.g.dart';

@JsonSerializable()
class Header_SystemReq_Model {
  final String header;

  Header_SystemReq_Model({
    required this.header,

  });

  factory Header_SystemReq_Model.fromJson(Map<String, dynamic> json) {
    return Header_SystemReq_Model(
        header: json['header'] ?? '',

    );
  }
  Map<String, dynamic> toJson() => _$Header_SystemReq_ModelToJson(this);
}