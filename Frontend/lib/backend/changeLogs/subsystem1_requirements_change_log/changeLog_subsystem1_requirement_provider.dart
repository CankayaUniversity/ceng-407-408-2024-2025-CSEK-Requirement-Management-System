import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'changeLog_subsystem1_requirement_model.dart';
import 'changeLog_subsystem1_requirement_api_service.dart';

final subsystem1RequirementChangeLogApiProvider = Provider<Subsystem1RequirementChangeLogApiService>((ref) {
  return Subsystem1RequirementChangeLogApiService();
});

final subsystem1RequirementChangeLogListProvider =
FutureProvider<List<Subsystem1RequirementChangeLog>>((ref) async {
  final api = ref.read(subsystem1RequirementChangeLogApiProvider);
  return await api.getAll();
});