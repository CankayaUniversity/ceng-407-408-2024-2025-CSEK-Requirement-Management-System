import 'package:dio/dio.dart';
import 'header_userreq_model.dart';

class HeaderApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:9500/user-requirements'));

  Future<List<Header_UserReq_Model>> getRequirements() async {
    final response = await dio.get('/headers');
    return (response.data as List)
        .map((e) => Header_UserReq_Model.fromJson(e))
        .toList();
  }

  Future<Header_UserReq_Model> createRequirement(Header_UserReq_Model newRequirement) async {
    final response = await dio.post(
      '/headers',
      data: newRequirement.toJson(),
    );
    return Header_UserReq_Model.fromJson(response.data);
  }
}


