import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sub3_attribute_model.dart';
import 'sub3_attribute_api_service.dart';

/// Provides a list of requirements by fetching from the backend API.
final sub3AttributeListProvider = FutureProvider<List<Sub3AttributeModel>>((ref) async {
  final apiService = Sub3AttributeApiService();
  return await apiService.getRequirements();
});