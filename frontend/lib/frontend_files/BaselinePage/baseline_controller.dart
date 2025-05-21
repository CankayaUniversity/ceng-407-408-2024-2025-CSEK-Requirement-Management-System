import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/backend/projects/selected_project_provider.dart';
import 'package:frontend/frontend_files/loginpage/auth_service.dart';

class SnapshotController {
  static Future<void> loadUserInfo(Function(String, List<String>) onLoaded) async {
    final info = await AuthService.getUserInfo();
    final roles = await AuthService.getUserRoles();
    onLoaded(info?['username'] ?? 'Bilinmiyor', roles);
  }

  static Future<String?> showDescriptionDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Açıklama Girin"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Version açıklaması'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text("Gönder"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("İptal"),
          ),
        ],
      ),
    );
  }

  static Future<void> sendSnapshotRequests({
    required WidgetRef ref,
    required BuildContext context,
    required List<String> selectedModules,
    required String description,
    required String username,
  }) async {
    final selectedProject = ref.read(selectedProjectProvider);
    if (selectedProject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Önce bir proje seçilmelidir.")),
      );
      return;
    }

    final now = DateTime.now().toUtc();
    final timestamp = "${now.toIso8601String().split('.').first.replaceAll(':', '-')}" "Z";

    final uriBase = "http://localhost:9500";
    final payload = {
      "projectId": selectedProject.id,
      "projectName": selectedProject.name,
      "username": username,
      "timestamp": timestamp,
      "description": description,
    };

    final Map<String, String> endpoints = {
      "user-requirements": "/user-requirements/baseline/send/user-requirements",
      "system-requirements": "/system-requirements/baseline/send/system-requirements",
      "subsystem1-requirements": "/subsystem-requirements/baseline/send/subsystem1-requirements",
      "subsystem2-requirements": "/subsystem-requirements/baseline/send/subsystem2-requirements",
      "subsystem3-requirements": "/subsystem-requirements/baseline/send/subsystem3-requirements",
    };

    bool allSuccess = true;
    List<String> failedModules = [];

    for (final module in selectedModules) {
      final endpoint = endpoints[module];
      if (endpoint == null) continue;

      final response = await http.post(
        Uri.parse('$uriBase$endpoint'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("✅ Başarılı: $module");
      } else {
        debugPrint("❌ Hata: $module - ${response.statusCode}");
        allSuccess = false;
        failedModules.add(module);
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          allSuccess
              ? "✅ Tüm snapshot'lar başarıyla gönderildi."
              : "⚠️ Bazı modüller başarısız: ${failedModules.join(', ')}",
        ),
      ),
    );
  }

  static Future<List<String>> fetchAvailableBaselines(String projectName) async {
    final response = await http.get(
      Uri.parse("http://localhost:9500/snapshot/baselines?projectName=$projectName"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      return list.cast<String>();
    } else {
      throw Exception("Baseline listesi alınamadı.");
    }
  }

  static Future<void> fetchBaselines({
    required BuildContext context,
    required WidgetRef ref,
    required Function(List<String>) onLoaded,
  }) async {
    final selectedProject = ref.read(selectedProjectProvider);
    if (selectedProject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen önce bir proje seçin.")),
      );
      return;
    }

    final projectName = selectedProject.name;
    final uri = Uri.parse("http://localhost:9500/snapshot/baselines?projectName=$projectName");

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final baselines = data.map((e) => e.toString()).toList();
        onLoaded(baselines);
      } else {
        throw Exception("Sunucu hatası: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e")),
      );
    }
  }

  static Future<Map<String, dynamic>> fetchSnapshotContent({
    required String projectName,
    required String baselineName,
  }) async {
    final uri = Uri.parse(
      "http://localhost:9500/snapshot/baselines/content?projectName=$projectName&baselineName=$baselineName",
    );

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final outerJson = jsonDecode(response.body);

      final Map<String, dynamic> parsed = {};
      for (final entry in outerJson.entries) {
        try {
          parsed[entry.key] = jsonDecode(entry.value);
        } catch (_) {
          parsed[entry.key] = entry.value;
        }
      }
      return parsed;
    } else {
      throw Exception("Snapshot verisi alınamadı: ${response.statusCode}");
    }
  }


}