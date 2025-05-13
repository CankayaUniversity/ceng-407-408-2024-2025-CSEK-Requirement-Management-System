import 'package:dio/dio.dart';
import 'changeLog_subsystem2_requirement_model.dart';

class Subsystem2RequirementChangeLogApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:9500/change-log'));

  Future<List<Subsystem2RequirementChangeLog>> getAll() async {
    final response = await dio.get('/subsystem2Requirement-changelog');
    return (response.data as List)
        .map((e) => Subsystem2RequirementChangeLog.fromJson(e))
        .toList();
  }

  Future<Subsystem2RequirementChangeLog> create(Subsystem2RequirementChangeLog newLog) async {
    final response = await dio.post(
      '/subsystem2Requirement-changelog',
      data: newLog.toJson(),
    );
    return Subsystem2RequirementChangeLog.fromJson(response.data);
  }


}