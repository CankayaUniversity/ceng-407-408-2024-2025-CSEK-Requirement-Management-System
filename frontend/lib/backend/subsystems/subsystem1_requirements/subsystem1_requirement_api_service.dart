import 'package:dio/dio.dart';
import 'subsystem1_requirement_model.dart';

class Subsystem1RequirementApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:9500/subsystem-requirements'));

  Future<List<Subsystem1ReqModel>> getRequirements() async {
    final response = await dio.get('/subsystem1');
    return (response.data as List)
        .map((e) => Subsystem1ReqModel.fromJson(e))
        .toList();
  }
  Future<Subsystem1ReqModel> createRequirement(Subsystem1ReqModel newRequirement) async {
    final response = await dio.post(
      '/subsystem1',
      data: newRequirement.toJson(),
    );
    print('Gönderilen veri: ${newRequirement.toJson()}');
    return Subsystem1ReqModel.fromJson(response.data);
  }
}


