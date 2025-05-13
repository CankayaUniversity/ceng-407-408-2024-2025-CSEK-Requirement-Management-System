import 'package:dio/dio.dart';
import 'system_attribute_model.dart';

class SystemAttributeApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:9500/system-requirements'));

  Future<List<SystemAttributeModel>> getRequirements() async {
    final response = await dio.get('/attributes');
    return (response.data as List)
        .map((e) => SystemAttributeModel.fromJson(e))
        .toList();
  }

  Future<SystemAttributeModel> createRequirement(SystemAttributeModel newRequirement) async {
    final response = await dio.post(
      '/attributes',
      data: newRequirement.toJson(),
    );
    return SystemAttributeModel.fromJson(response.data);
  }


  Future<SystemAttributeModel> updateRequirement(SystemAttributeModel updatedRequirement) async {
    final response = await dio.put(
      '/attributes/${updatedRequirement.id}',
      data: updatedRequirement.toJson(),
    );
    return SystemAttributeModel.fromJson(response.data);
  }

  Future<void> deleteRequirement(String id) async {
    await dio.delete('/attributes/$id');
  }
}


