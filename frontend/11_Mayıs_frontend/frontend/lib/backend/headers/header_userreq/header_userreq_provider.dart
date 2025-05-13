import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'header_userreq_model.dart';
import 'header_userreq_api_service.dart';

/// Provides a list of requirements by fetching from the backend API.
final headerUserReqModelListProvider = FutureProvider<List<Header_UserReq_Model>>((ref) async {
  final apiService = HeaderApiService();
  return await apiService.getRequirements();
});