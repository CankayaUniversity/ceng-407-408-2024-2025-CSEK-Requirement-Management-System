import 'package:dio/dio.dart';
import 'changeLog_user_requirement_model.dart';

class UserRequirementChangeLogApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:9500/change-log'));

  Future<List<UserRequirementChangeLog>> getAll() async {
    final response = await dio.get('/userRequirement-changelog');
    return (response.data as List)
        .map((e) => UserRequirementChangeLog.fromJson(e))
        .toList();
  }

  Future<UserRequirementChangeLog> create(UserRequirementChangeLog newLog) async {
    final response = await dio.post(
      '/userRequirement-changelog',
      data: newLog.toJson(),
    );
    return UserRequirementChangeLog.fromJson(response.data);
  }


}