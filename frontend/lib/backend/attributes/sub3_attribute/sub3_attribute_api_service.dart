import 'package:dio/dio.dart';
import 'sub3_attribute_model.dart';

class Sub3AttributeApiService {
  final Dio dio = Dio(
    BaseOptions(baseUrl: 'http://localhost:9500/subsystem-requirements'),
  );

  Future<List<Sub3AttributeModel>> getRequirements() async {
    final response = await dio.get('/subsystem3-attributes');
    return (response.data as List)
        .map((e) => Sub3AttributeModel.fromJson(e))
        .toList();
  }

  Future<Sub3AttributeModel> createRequirement(
    Sub3AttributeModel newRequirement,
  ) async {
    final response = await dio.post(
      '/subsystem3-attributes',
      data: newRequirement.toJson(),
    );
    return Sub3AttributeModel.fromJson(response.data);
  }

  Future<Sub3AttributeModel> updateRequirement(
    Sub3AttributeModel updatedRequirement,
  ) async {
    print(" API NE IDSİ YOOLUYOZ   ${updatedRequirement.id}");
    final response = await dio.put(
      '/subsystem3-attributes/${updatedRequirement.id}',
      data: updatedRequirement.toJson(),
    );
    return Sub3AttributeModel.fromJson(response.data);
  }

  Future<void> deleteRequirement(String id) async {
    await dio.delete('/subsystem3-attributes/$id');
  }
}
