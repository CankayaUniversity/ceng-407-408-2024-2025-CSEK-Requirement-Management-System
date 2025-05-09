import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'subsystem1_requirement_model.dart';
import 'subsystem1_requirement_api_service.dart';

/// Provides a list of requirements by fetching from the backend API.
final subsystem1RequirementListProvider = FutureProvider<List<Subsystem1ReqModel>>((ref) async {
  final apiService = Subsystem1RequirementApiService();
  return await apiService.getRequirements();
});