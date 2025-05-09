import 'package:dio/dio.dart';
import 'header_sub2req_model.dart';

class HeaderApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:9500/subsystem-requirements'));

  Future<List<Header_Sub2Req_Model>> getRequirements() async {
    final response = await dio.get('/subsystem2-header');
    return (response.data as List)
        .map((e) => Header_Sub2Req_Model.fromJson(e))
        .toList();
  }

  Future<Header_Sub2Req_Model> createRequirement(Header_Sub2Req_Model newRequirement) async {
    final response = await dio.post(
      '/subsystem2-header',
      data: newRequirement.toJson(),
    );
    return Header_Sub2Req_Model.fromJson(response.data);
  }
}


