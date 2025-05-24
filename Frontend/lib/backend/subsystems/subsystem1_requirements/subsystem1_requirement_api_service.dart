import 'package:dio/dio.dart';
import 'subsystem1_requirement_model.dart';

class Subsystem1RequirementApiService {
  final Dio dio = Dio(
    BaseOptions(baseUrl: 'http://localhost:9500/subsystem-requirements'),
  );

  Future<List<Subsystem1ReqModel>> getRequirements(String projectId) async {
    final response = await dio.get('/subsystem1/$projectId');
    final list =
        (response.data as List)
            .map((e) => Subsystem1ReqModel.fromJson(e))
            .toList();

    list.sort((a, b) {
      final numA = int.tryParse(a.title.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      final numB = int.tryParse(b.title.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      return numA.compareTo(numB);
    });

    return list;
  }

  Future<Subsystem1ReqModel> createRequirement(
    Subsystem1ReqModel newRequirement,
  ) async {
    final response = await dio.post(
      '/subsystem1',
      data: newRequirement.toJson(),
    );
    return Subsystem1ReqModel.fromJson(response.data);
  }

  Future<Subsystem1ReqModel> updateRequirement(
    Subsystem1ReqModel requirement,
  ) async {
    final response = await dio.put(
      '/subsystem1/${requirement.id}',
      data: requirement.toJson(),
    );
    return Subsystem1ReqModel.fromJson(response.data);
  }

  Future<void> deleteRequirement(String id) async {
    await dio.delete('/subsystem1/$id');
  }
}
