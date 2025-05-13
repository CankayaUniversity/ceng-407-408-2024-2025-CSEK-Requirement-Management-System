import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'system_requirement_model.dart';
import 'system_requirement_api_service.dart';

/// Provides a list of requirements by fetching from the backend API.
final systemRequirementListProvider = FutureProvider<List<SystemReqModel>>((ref) async {
  final apiService = SystemRequirementApiService();
  return await apiService.getRequirements();
});