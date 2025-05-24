import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'projects_model.dart';
import 'projects_api_service.dart';

final projectsNotifierProvider =
    StateNotifierProvider<ProjectsNotifier, List<ProjectsModel>>((ref) {
      return ProjectsNotifier();
    });

class ProjectsNotifier extends StateNotifier<List<ProjectsModel>> {
  ProjectsNotifier() : super([]) {
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final projects = await ProjectsApiService().getProjects();
    state = projects;
  }

  Future<void> addProject(ProjectsModel project) async {
    final newProject = await ProjectsApiService().createProject(project);
    if (newProject != null) {
      state = [...state, newProject];
    }
  }
}
