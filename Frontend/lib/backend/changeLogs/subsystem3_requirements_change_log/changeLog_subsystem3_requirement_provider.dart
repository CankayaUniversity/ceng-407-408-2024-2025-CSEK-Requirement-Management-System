import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'changeLog_subsystem3_requirement_model.dart';
import 'changeLog_subsystem3_requirement_api_service.dart';

final subsystem3RequirementChangeLogApiProvider = Provider<Subsystem3RequirementChangeLogApiService>((ref) {
  return Subsystem3RequirementChangeLogApiService();
});

final subsystem3RequirementChangeLogListProvider =
FutureProvider<List<Subsystem3RequirementChangeLog>>((ref) async {
  final api = ref.read(subsystem3RequirementChangeLogApiProvider);
  return await api.getAll();
});