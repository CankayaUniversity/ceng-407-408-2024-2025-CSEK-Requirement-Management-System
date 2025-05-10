import 'package:dio/dio.dart';
import 'header_sub1req_model.dart';

class HeaderSub1ApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:9500/subsystem-requirements'));

  Future<List<Header_Sub1Req_Model>> getRequirements() async {
    final response = await dio.get('/subsystem1-header');
    return (response.data as List)
        .map((e) => Header_Sub1Req_Model.fromJson(e))
        .toList();
  }

  Future<Header_Sub1Req_Model> createRequirement(Header_Sub1Req_Model newRequirement) async {
    final response = await dio.post(
      '/subsystem1-header',
      data: newRequirement.toJson(),
    );
    return Header_Sub1Req_Model.fromJson(response.data);
  }
}


