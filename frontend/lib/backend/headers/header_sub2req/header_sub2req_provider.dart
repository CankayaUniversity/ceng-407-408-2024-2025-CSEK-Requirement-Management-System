import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'header_sub2req_model.dart';
import 'header_sub2req_api_service.dart';

/// Provides a list of requirements by fetching from the backend API.
final headerSub2ReqModelListProvider = FutureProvider<List<Header_Sub2Req_Model>>((ref) async {
  final apiService = HeaderSub2ApiService();
  return await apiService.getRequirements();
});