import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'subsystem3_requirement_model.dart';
import 'subsystem3_requirement_api_service.dart';
import 'package:frontend/backend/projects/selected_project_provider.dart';

final subsystem3RequirementListProvider =
    FutureProvider.autoDispose<List<Subsystem3ReqModel>>((ref) async {
      final selectedProject = ref.watch(selectedProjectProvider);

      if (selectedProject == null || selectedProject.id.isEmpty) {
        return [];
      }

      final apiService = Subsystem3RequirementApiService();
      return await apiService.getRequirements(selectedProject.id);
    });
