import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'changeLog_user_requirement_model.dart';
import 'changeLog_user_requirement_api_service.dart';

final userRequirementChangeLogApiProvider = Provider<UserRequirementChangeLogApiService>((ref) {
  return UserRequirementChangeLogApiService();
});

final userRequirementChangeLogListProvider =
FutureProvider<List<UserRequirementChangeLog>>((ref) async {
  final api = ref.read(userRequirementChangeLogApiProvider);
  return await api.getAll();
});