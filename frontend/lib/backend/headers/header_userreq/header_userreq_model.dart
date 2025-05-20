import 'package:json_annotation/json_annotation.dart';

part 'header_userreq_model.g.dart';

@JsonSerializable()
class Header_UserReq_Model {
  final String header;

  Header_UserReq_Model({
    required this.header,

  });

  factory Header_UserReq_Model.fromJson(Map<String, dynamic> json) {
    return Header_UserReq_Model(
        header: json['header'] ?? '',

    );
  }
  Map<String, dynamic> toJson() => _$Header_UserReq_ModelToJson(this);
}