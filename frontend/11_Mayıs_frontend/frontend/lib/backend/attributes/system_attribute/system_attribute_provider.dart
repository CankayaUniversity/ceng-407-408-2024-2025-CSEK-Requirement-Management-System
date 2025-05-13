import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'system_attribute_model.dart';
import 'system_attribute_api_service.dart';

/// Provides a list of requirements by fetching from the backend API.
final systemAttributeListProvider = FutureProvider<List<SystemAttributeModel>>((ref) async {
  final apiService = SystemAttributeApiService();
  return await apiService.getRequirements();
});