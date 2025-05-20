import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'subsystem1_requirement_model.dart';
import 'subsystem1_requirement_api_service.dart';
import 'package:frontend/backend/projects/selected_project_provider.dart';

final subsystem1RequirementListProvider =
    FutureProvider.autoDispose<List<Subsystem1ReqModel>>((ref) async {
      final selectedProject = ref.watch(selectedProjectProvider);

      if (selectedProject == null || selectedProject.id.isEmpty) {
        return [];
      }

      final apiService = Subsystem1RequirementApiService();
      return await apiService.getRequirements(selectedProject.id);
    });
