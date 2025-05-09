import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'header_sub3req_model.dart';
import 'header_sub3req_api_service.dart';

/// Provides a list of requirements by fetching from the backend API.
final headerSub3ReqModelListProvider = FutureProvider<List<Header_Sub3Req_Model>>((ref) async {
  final apiService = HeaderApiService();
  return await apiService.getRequirements();
});