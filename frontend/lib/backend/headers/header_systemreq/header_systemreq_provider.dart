import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'header_systemreq_model.dart';
import 'header_systemreq_api_service.dart';

/// Provides a list of requirements by fetching from the backend API.
final headerSystemReqModelListProvider = FutureProvider<List<Header_SystemReq_Model>>((ref) async {
  final apiService = HeaderApiService();
  return await apiService.getRequirements();
});