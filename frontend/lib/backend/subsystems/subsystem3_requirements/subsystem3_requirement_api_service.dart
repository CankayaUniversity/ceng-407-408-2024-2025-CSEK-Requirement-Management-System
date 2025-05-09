import 'package:dio/dio.dart';
import 'subsystem3_requirement_model.dart';

class Subsystem3RequirementApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:9500/subsystem-requirements'));

  Future<List<Subsystem3ReqModel>> getRequirements() async {
    final response = await dio.get('/subsystem3');
    return (response.data as List)
        .map((e) => Subsystem3ReqModel.fromJson(e))
        .toList();
  }
  Future<Subsystem3ReqModel> createRequirement(Subsystem3ReqModel newRequirement) async {
    final response = await dio.post(
      '/subsystem3',
      data: newRequirement.toJson(),
    );
    print('Gönderilen veri: ${newRequirement.toJson()}');
    return Subsystem3ReqModel.fromJson(response.data);
  }
}


