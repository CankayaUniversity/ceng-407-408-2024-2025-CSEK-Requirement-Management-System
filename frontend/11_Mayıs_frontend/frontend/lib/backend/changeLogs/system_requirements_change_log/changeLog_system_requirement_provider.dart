import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'changeLog_system_requirement_model.dart';
import 'changeLog_system_requirement_api_service.dart';

final systemRequirementChangeLogApiProvider = Provider<SystemRequirementChangeLogApiService>((ref) {
  return SystemRequirementChangeLogApiService();
});

final systemRequirementChangeLogListProvider =
FutureProvider<List<SystemRequirementChangeLog>>((ref) async {
  final api = ref.read(systemRequirementChangeLogApiProvider);
  return await api.getAll();
});