import 'package:dio/dio.dart';
import 'subsystem3_requirement_model.dart';

class Subsystem3RequirementApiService {
  final Dio dio = Dio(
    BaseOptions(baseUrl: 'http://localhost:9500/subsystem-requirements'),
  );

  Future<List<Subsystem3ReqModel>> getRequirements() async {
    final response = await dio.get('/subsystem3');
    final list =
        (response.data as List)
            .map((e) => Subsystem3ReqModel.fromJson(e))
            .toList();

    list.sort((a, b) {
      final numA = int.tryParse(a.title.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      final numB = int.tryParse(b.title.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      return numA.compareTo(numB);
    });
    return list;
  }

  Future<Subsystem3ReqModel> createRequirement(
    Subsystem3ReqModel newRequirement,
  ) async {
    final response = await dio.post(
      '/subsystem3',
      data: newRequirement.toJson(),
    );
    print('Gönderilen veri: ${newRequirement.toJson()}');
    return Subsystem3ReqModel.fromJson(response.data);
  }

  Future<Subsystem3ReqModel> updateRequirement(
    Subsystem3ReqModel requirement,
  ) async {
    final response = await dio.put(
      '/subsystem3/${requirement.id}',
      data: requirement.toJson(),
    );
    return Subsystem3ReqModel.fromJson(response.data);
  }

  Future<void> deleteRequirement(String id) async {
    await dio.delete('/subsystem3/$id');
  }
}
