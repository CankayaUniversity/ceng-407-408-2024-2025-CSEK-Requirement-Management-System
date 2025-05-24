import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'changeLog_subsystem2_requirement_model.dart';
import 'changeLog_subsystem2_requirement_api_service.dart';

final subsystem2RequirementChangeLogApiProvider = Provider<Subsystem2RequirementChangeLogApiService>((ref) {
  return Subsystem2RequirementChangeLogApiService();
});

final subsystem2RequirementChangeLogListProvider =
FutureProvider<List<Subsystem2RequirementChangeLog>>((ref) async {
  final api = ref.read(subsystem2RequirementChangeLogApiProvider);
  return await api.getAll();
});