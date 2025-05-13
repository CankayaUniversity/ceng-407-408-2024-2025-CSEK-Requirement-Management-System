import 'package:dio/dio.dart';
import 'user_requirement_model.dart';

class UserRequirementApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:9500/user-requirements'));

  Future<List<UserReqModel>> getRequirements() async {
    final response = await dio.get('/user-requirements');
    final list = (response.data as List)
        .map((e) => UserReqModel.fromJson(e))
        .toList();

    list.sort((a, b) {
      final numA = int.tryParse(a.title.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      final numB = int.tryParse(b.title.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      return numA.compareTo(numB);
    });

    return list;
  }

  Future<UserReqModel> createRequirement(UserReqModel newRequirement) async {
    final response = await dio.post(
      '/user-requirements',
      data: newRequirement.toJson(),
    );
    return UserReqModel.fromJson(response.data);
  }

  Future<UserReqModel> updateRequirement(UserReqModel requirement) async {
    final response = await dio.put(
      '/user-requirements/${requirement.id}',
      data: requirement.toJson(),
    );
    return UserReqModel.fromJson(response.data);
  }

  Future<void> deleteRequirement(String id) async {
    await dio.delete('/user-requirements/$id');
  }



}


