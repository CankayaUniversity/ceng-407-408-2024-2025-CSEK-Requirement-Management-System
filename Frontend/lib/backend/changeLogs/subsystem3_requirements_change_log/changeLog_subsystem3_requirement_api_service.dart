import 'package:dio/dio.dart';
import 'changeLog_subsystem3_requirement_model.dart';

class Subsystem3RequirementChangeLogApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:9500/change-log'));

  Future<List<Subsystem3RequirementChangeLog>> getAll() async {
    final response = await dio.get('/subsystem3Requirement-changelog/all');
    return (response.data as List)
        .map((e) => Subsystem3RequirementChangeLog.fromJson(e))
        .toList();
  }

  Future<Subsystem3RequirementChangeLog> create(
    Subsystem3RequirementChangeLog newLog,
  ) async {
    final response = await dio.post(
      '/subsystem3Requirement-changelog',
      data: newLog.toJson(),
    );
    return Subsystem3RequirementChangeLog.fromJson(response.data);
  }
}
