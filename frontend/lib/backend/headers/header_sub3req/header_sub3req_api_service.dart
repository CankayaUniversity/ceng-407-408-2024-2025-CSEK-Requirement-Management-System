import 'package:dio/dio.dart';
import 'header_sub3req_model.dart';

class HeaderSub3ApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:9500/subsystem-requirements'));

  Future<List<Header_Sub3Req_Model>> getRequirements() async {
    final response = await dio.get('/subsystem3-header');
    return (response.data as List)
        .map((e) => Header_Sub3Req_Model.fromJson(e))
        .toList();
  }

  Future<Header_Sub3Req_Model> createRequirement(Header_Sub3Req_Model newRequirement) async {
    final response = await dio.post(
      '/subsystem3-header',
      data: newRequirement.toJson(),
    );
    return Header_Sub3Req_Model.fromJson(response.data);
  }
}


