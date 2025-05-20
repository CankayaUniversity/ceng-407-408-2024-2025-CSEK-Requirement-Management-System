import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'subsystem2_requirement_model.dart';
import 'subsystem2_requirement_api_service.dart';
import 'package:frontend/backend/projects/selected_project_provider.dart';

final subsystem2RequirementListProvider =
    FutureProvider.autoDispose<List<Subsystem2ReqModel>>((ref) async {
      final selectedProject = ref.watch(selectedProjectProvider);

      if (selectedProject == null || selectedProject.id.isEmpty) {
        return [];
      }

      final apiService = Subsystem2RequirementApiService();
      return await apiService.getRequirements(selectedProject.id);
    });
