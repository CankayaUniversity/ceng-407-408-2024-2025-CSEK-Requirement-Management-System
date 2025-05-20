import 'package:dio/dio.dart';
import 'changeLog_subsystem1_requirement_model.dart';

class Subsystem1RequirementChangeLogApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:9500/change-log'));

  Future<List<Subsystem1RequirementChangeLog>> getAll() async {
    final response = await dio.get('/subsystem1Requirement-changelog/all');
    return (response.data as List)
        .map((e) => Subsystem1RequirementChangeLog.fromJson(e))
        .toList();
  }

  Future<Subsystem1RequirementChangeLog> create(
    Subsystem1RequirementChangeLog newLog,
  ) async {
    final response = await dio.post(
      '/subsystem1Requirement-changelog',
      data: newLog.toJson(),
    );
    return Subsystem1RequirementChangeLog.fromJson(response.data);
  }
}
