import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_requirement_model.dart';
import 'user_requirement_api_service.dart';

/// Provides a list of requirements by fetching from the backend API.
final userRequirementListProvider = FutureProvider<List<UserReqModel>>((ref) async {
  final apiService = UserRequirementApiService();
  return await apiService.getRequirements();
});