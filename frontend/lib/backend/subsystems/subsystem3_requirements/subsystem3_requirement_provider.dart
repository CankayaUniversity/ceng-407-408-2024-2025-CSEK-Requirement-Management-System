import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'subsystem3_requirement_model.dart';
import 'subsystem3_requirement_api_service.dart';

/// Provides a list of requirements by fetching from the backend API.
final subsystem3RequirementListProvider = FutureProvider<List<Subsystem3ReqModel>>((ref) async {
  final apiService = Subsystem3RequirementApiService();
  return await apiService.getRequirements();
});