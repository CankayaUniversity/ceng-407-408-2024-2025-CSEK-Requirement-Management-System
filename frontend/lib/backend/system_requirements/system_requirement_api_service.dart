import 'package:dio/dio.dart';
import 'system_requirement_model.dart';

class SystemRequirementApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:9500/system-requirements'));

  Future<List<SystemReqModel>> getRequirements() async {
    final response = await dio.get('/system-requirements');
    return (response.data as List)
        .map((e) => SystemReqModel.fromJson(e))
        .toList();
  }
  Future<SystemReqModel> createRequirement(SystemReqModel newRequirement) async {
    final response = await dio.post(
      '/system-requirements',
      data: newRequirement.toJson(),
    );
    print('Gönderilen veri: ${newRequirement.toJson()}');
    return SystemReqModel.fromJson(response.data);
  }
}


