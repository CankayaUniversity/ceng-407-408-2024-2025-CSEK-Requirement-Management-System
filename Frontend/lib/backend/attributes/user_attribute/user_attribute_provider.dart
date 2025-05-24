import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_attribute_model.dart';
import 'user_attribute_api_service.dart';

/// Provides a list of requirements by fetching from the backend API.
final userAttributeListProvider = FutureProvider<List<UserAttributeModel>>((ref) async {
  final apiService = UserAttributeApiService();
  return await apiService.getRequirements();
});