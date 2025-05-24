import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'header_sub1req_model.dart';
import 'header_sub1req_api_service.dart';

/// Provides a list of requirements by fetching from the backend API.
final sub1HeaderListProvider = FutureProvider<List<Header_Sub1Req_Model>>((ref) async {
  final apiService = HeaderSub1ApiService();
  return await apiService.getRequirements();
});