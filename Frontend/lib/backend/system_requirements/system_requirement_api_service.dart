import 'package:dio/dio.dart';
import 'system_requirement_model.dart';

class SystemRequirementApiService {
  final Dio dio = Dio(
    BaseOptions(baseUrl: 'http://localhost:9500/system-requirements'),
  );

  Future<List<SystemReqModel>> getRequirements(String projectId) async {
    final response = await dio.get('/system-requirements/$projectId');
    final list =
        (response.data as List).map((e) => SystemReqModel.fromJson(e)).toList();

    list.sort((a, b) {
      final numA = int.tryParse(a.title.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      final numB = int.tryParse(b.title.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      return numA.compareTo(numB);
    });

    return list;
  }

  Future<SystemReqModel> createRequirement(
    SystemReqModel newRequirement,
  ) async {
    final response = await dio.post(
      '/system-requirements',
      data: newRequirement.toJson(),
    );
    return SystemReqModel.fromJson(response.data);
  }

  Future<SystemReqModel> updateRequirement(SystemReqModel requirement) async {
    final response = await dio.put(
      '/system-requirements/${requirement.id}',
      data: requirement.toJson(),
    );
    return SystemReqModel.fromJson(response.data);
  }

  Future<void> deleteRequirement(String id) async {
    await dio.delete('/system-requirements/$id');
  }
}
