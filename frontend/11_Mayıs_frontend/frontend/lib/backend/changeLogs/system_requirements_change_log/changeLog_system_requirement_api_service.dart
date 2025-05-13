import 'package:dio/dio.dart';
import 'changeLog_system_requirement_model.dart';

class SystemRequirementChangeLogApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:9500/change-log'));

  Future<List<SystemRequirementChangeLog>> getAll() async {
    final response = await dio.get('/systemRequirement-changelog');
    return (response.data as List)
        .map((e) => SystemRequirementChangeLog.fromJson(e))
        .toList();
  }

  Future<SystemRequirementChangeLog> create(SystemRequirementChangeLog newLog) async {
    final response = await dio.post(
      '/systemRequirement-changelog',
      data: newLog.toJson(),
    );
    return SystemRequirementChangeLog.fromJson(response.data);
  }


}