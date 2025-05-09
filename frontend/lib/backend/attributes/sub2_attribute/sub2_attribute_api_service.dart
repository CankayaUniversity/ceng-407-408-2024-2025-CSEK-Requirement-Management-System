import 'package:dio/dio.dart';
import 'sub2_attribute_model.dart';

class Sub2AttributeApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:9500/subsystem-requirements'));

  Future<List<Sub2AttributeModel>> getRequirements() async {
    final response = await dio.get('/subsystem2-attributes');
    return (response.data as List)
        .map((e) => Sub2AttributeModel.fromJson(e))
        .toList();
  }

  Future<Sub2AttributeModel> createRequirement(Sub2AttributeModel newRequirement) async {
    final response = await dio.post(
      '/subsystem2-attributes',
      data: newRequirement.toJson(),
    );
    return Sub2AttributeModel.fromJson(response.data);
  }
}


