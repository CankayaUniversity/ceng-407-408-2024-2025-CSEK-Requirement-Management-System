import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'subsystem2_requirement_model.dart';
import 'subsystem2_requirement_api_service.dart';

/// Provides a list of requirements by fetching from the backend API.
final subsystem2RequirementListProvider = FutureProvider<List<Subsystem2ReqModel>>((ref) async {
  final apiService = Subsystem2RequirementApiService();
  return await apiService.getRequirements();
});