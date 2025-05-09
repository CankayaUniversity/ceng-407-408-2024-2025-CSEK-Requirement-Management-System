import 'package:dio/dio.dart';
import 'user_attribute_model.dart';

class UserAttributeApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:9500/user-requirements'));

  Future<List<UserAttributeModel>> getRequirements() async {
    final response = await dio.get('/attributes');
    return (response.data as List)
        .map((e) => UserAttributeModel.fromJson(e))
        .toList();
  }

  Future<UserAttributeModel> createRequirement(UserAttributeModel newRequirement) async {
    final response = await dio.post(
      '/attributes',
      data: newRequirement.toJson(),
    );
    return UserAttributeModel.fromJson(response.data);
  }
}


