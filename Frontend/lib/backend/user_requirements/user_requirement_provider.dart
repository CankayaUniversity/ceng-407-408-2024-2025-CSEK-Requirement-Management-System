import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_requirement_model.dart';
import 'user_requirement_api_service.dart';
import 'package:frontend/backend/projects/selected_project_provider.dart';

final userRequirementListProvider =
    FutureProvider.autoDispose<List<UserReqModel>>((ref) async {
      final selectedProject = ref.watch(selectedProjectProvider);

      if (selectedProject == null || selectedProject.id.isEmpty) {
        return [];
      }

      final apiService = UserRequirementApiService();
      return await apiService.getRequirements(selectedProject.id);
    });
