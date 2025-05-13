import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sub2_attribute_model.dart';
import 'sub2_attribute_api_service.dart';

/// Provides a list of requirements by fetching from the backend API.
final sub2AttributeListProvider = FutureProvider<List<Sub2AttributeModel>>((ref) async {
  final apiService = Sub2AttributeApiService();
  return await apiService.getRequirements();
});