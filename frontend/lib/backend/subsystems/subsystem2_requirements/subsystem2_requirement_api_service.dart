import 'package:dio/dio.dart';
import 'subsystem2_requirement_model.dart';

class Subsystem2RequirementApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:9500/subsystem-requirements'));

  Future<List<Subsystem2ReqModel>> getRequirements() async {
    final response = await dio.get('/subsystem2');
    return (response.data as List)
        .map((e) => Subsystem2ReqModel.fromJson(e))
        .toList();
  }
  Future<Subsystem2ReqModel> createRequirement(Subsystem2ReqModel newRequirement) async {
    final response = await dio.post(
      '/subsystem2',
      data: newRequirement.toJson(),
    );
    print('Gönderilen veri: ${newRequirement.toJson()}');
    return Subsystem2ReqModel.fromJson(response.data);
  }
}


