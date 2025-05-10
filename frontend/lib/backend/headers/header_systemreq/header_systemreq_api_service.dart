import 'package:dio/dio.dart';
import 'header_systemreq_model.dart';

class HeaderSystemApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:9500/system-requirements'));

  Future<List<Header_SystemReq_Model>> getRequirements() async {
    final response = await dio.get('/headers');
    return (response.data as List)
        .map((e) => Header_SystemReq_Model.fromJson(e))
        .toList();
  }

  Future<Header_SystemReq_Model> createRequirement(Header_SystemReq_Model newRequirement) async {
    final response = await dio.post(
      '/headers',
      data: newRequirement.toJson(),
    );
    return Header_SystemReq_Model.fromJson(response.data);
  }
}


