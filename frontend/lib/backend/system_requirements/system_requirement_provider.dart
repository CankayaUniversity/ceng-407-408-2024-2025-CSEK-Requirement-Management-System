import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'system_requirement_model.dart';
import 'system_requirement_api_service.dart';
import 'package:frontend/backend/projects/selected_project_provider.dart';

/// Provides a list of requirements by fetching from the backend API.
final systemRequirementListProvider =
    FutureProvider.autoDispose<List<SystemReqModel>>((ref) async {
      final selectedProject = ref.watch(selectedProjectProvider);

      if (selectedProject == null || selectedProject.id.isEmpty) {
        return [];
      }

      final apiService = SystemRequirementApiService();
      return await apiService.getRequirements(selectedProject.id);
    });
