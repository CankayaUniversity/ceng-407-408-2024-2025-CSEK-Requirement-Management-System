import 'package:dio/dio.dart';
import 'sub1_attribute_model.dart';

class Sub1AttributeApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:9500/subsystem-requirements'));

  Future<List<Sub1AttributeModel>> getRequirements() async {
    final response = await dio.get('/subsystem1-attributes');
    return (response.data as List)
        .map((e) => Sub1AttributeModel.fromJson(e))
        .toList();
  }

  Future<Sub1AttributeModel> createRequirement(Sub1AttributeModel newRequirement) async {
    final response = await dio.post(
      '/subsystem1-attributes',
      data: newRequirement.toJson(),
    );
    return Sub1AttributeModel.fromJson(response.data);
  }
}


