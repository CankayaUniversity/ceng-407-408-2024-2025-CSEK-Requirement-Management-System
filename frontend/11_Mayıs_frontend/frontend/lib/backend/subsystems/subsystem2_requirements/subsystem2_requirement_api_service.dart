import 'package:dio/dio.dart';
import 'subsystem2_requirement_model.dart';

class Subsystem2RequirementApiService {
  final Dio dio = Dio(
    BaseOptions(baseUrl: 'http://localhost:9500/subsystem-requirements'),
  );

  Future<List<Subsystem2ReqModel>> getRequirements() async {
    final response = await dio.get('/subsystem2');
    final list =
        (response.data as List)
            .map((e) => Subsystem2ReqModel.fromJson(e))
            .toList();

    list.sort((a, b) {
      final numA = int.tryParse(a.title.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      final numB = int.tryParse(b.title.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      return numA.compareTo(numB);
    });
    return list;
  }

  Future<Subsystem2ReqModel> createRequirement(
    Subsystem2ReqModel newRequirement,
  ) async {
    final response = await dio.post(
      '/subsystem2',
      data: newRequirement.toJson(),
    );
    print('Gönderilen veri: ${newRequirement.toJson()}');
    return Subsystem2ReqModel.fromJson(response.data);
  }

  Future<Subsystem2ReqModel> updateRequirement(
    Subsystem2ReqModel requirement,
  ) async {
    final response = await dio.put(
      '/subsystem2/${requirement.id}',
      data: requirement.toJson(),
    );
    return Subsystem2ReqModel.fromJson(response.data);
  }

  Future<void> deleteRequirement(String id) async {
    await dio.delete('/subsystem2/$id');
  }
}
