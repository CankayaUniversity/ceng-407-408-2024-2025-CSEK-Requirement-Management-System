import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../backend/changeLogs/changeLog_requirement_interface_model.dart';
import 'package:frontend/frontend_files/loginpage/auth_service.dart';
import '../../backend/changeLogs/user_requirements_change_log/changeLog_user_requirement_provider.dart';

class ChangeLogController {
  /// Kullanıcı adını ve rollerini getirir
  static Future<void> loadUserInfo(Function(String, List<String>) onLoaded) async {
    final info = await AuthService.getUserInfo();
    final userRoles = await AuthService.getUserRoles();
    onLoaded(info?['username'] ?? 'Bilinmiyor', userRoles);
  }

  /// Tüm change log kayıtlarını getir
  static Future<List<RequirementChangeLog>> fetchAllLogs(WidgetRef ref) async {
    final api = ref.read(userRequirementChangeLogApiProvider);
    return await api.getAll();
  }

  static List<RequirementChangeLog> filterLogs({
    required List<RequirementChangeLog> logs,
    String? prefix,
    String? changeType,
    String? modifiedBy,
    DateTime? startDate,
    DateTime? endDate,
    String? exactTitle,
  }) {
    return logs.where((log) {
      final matchesPrefix = prefix == null || (log.oldTitle ?? '').startsWith(prefix);
      final matchesType = changeType == null || log.changeType == changeType;
      final matchesModifiedBy = modifiedBy == null || log.modifiedBy == modifiedBy;
      final matchesDate = (startDate == null || (log.modifiedAt?.isAfter(startDate) ?? false)) &&
          (endDate == null || (log.modifiedAt?.isBefore(endDate) ?? false));
      final matchesExact = (prefix != null && exactTitle != null && exactTitle.isNotEmpty)
          ? log.oldTitle == '$prefix-$exactTitle'
          : true;

      return matchesPrefix && matchesType && matchesModifiedBy && matchesDate && matchesExact;
    }).toList();
  }
}
