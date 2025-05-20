import 'package:dio/dio.dart';
import 'projects_model.dart';

class ProjectsApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:9500/projects'));

  Future<List<ProjectsModel>> getProjects() async {
    final response = await dio.get('/projects');
    final list =
        (response.data as List).map((e) => ProjectsModel.fromJson(e)).toList();

    list.sort((a, b) {
      final numA = int.tryParse(a.name.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      final numB = int.tryParse(b.name.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      return numA.compareTo(numB);
    });

    return list;
  }

  Future<ProjectsModel> createProject(ProjectsModel newProject) async {
    final response = await dio.post('/projects', data: newProject.toJson());
    return ProjectsModel.fromJson(response.data);
  }

  Future<void> deleteProject(String id) async {
    await dio.delete('/projects/$id');
  }
}
