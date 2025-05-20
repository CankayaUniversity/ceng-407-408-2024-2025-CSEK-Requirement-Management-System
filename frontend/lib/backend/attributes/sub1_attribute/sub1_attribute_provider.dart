import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sub1_attribute_model.dart';
import 'sub1_attribute_api_service.dart';

/// Provides a list of requirements by fetching from the backend API.
final sub1AttributeListProvider = FutureProvider<List<Sub1AttributeModel>>((ref) async {
  final apiService = Sub1AttributeApiService();
  return await apiService.getRequirements();
});