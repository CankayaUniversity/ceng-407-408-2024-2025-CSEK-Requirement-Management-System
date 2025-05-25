import 'dart:convert';
import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/backend/projects/selected_project_provider.dart';
import 'package:frontend/frontend_files/loginpage/auth_service.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:js_interop';
import 'dart:html' as html;


class ExportController {

  static Future<void> loadUserInfo(
      Function(String, List<String>) onLoaded,
      ) async {
    final info = await AuthService.getUserInfo();
    final roles = await AuthService.getUserRoles();
    onLoaded(info?['username'] ?? 'Bilinmiyor', roles);
  }

  static Future<List<String>> fetchBaselineList(WidgetRef ref) async {
    final selectedProject = ref.read(selectedProjectProvider);
    if (selectedProject == null) return [];

    final uri = Uri.parse(
        "http://localhost:9500/snapshot/baselines?projectName=${selectedProject.name}");

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<String>();
    } else {
      throw Exception("Sunucu hatası: ${response.statusCode}");
    }
  }

  static String formatBaselineName(String raw) {
    final parts = raw.split('_');
    if (parts.length < 2) return raw;

    final name = parts.sublist(0, parts.length - 1).join(' ');
    final rawTimestamp = parts.last
        .replaceAll('T', ' ')
        .replaceAll('Z', '')
        .replaceAll('-', ':');

    final dateTimeParts = rawTimestamp.split(' ');
    if (dateTimeParts.length != 2) return "$name – $rawTimestamp";

    final date = dateTimeParts[0].replaceAll(':', '-');
    final time = dateTimeParts[1];

    return "$name – $date $time";
  }

  static Future<void> exportBaseline({
    required String projectName,
    required String baselineName,
    required String format,
    String? wordStyle,
    required String downloadFilename, // ".pdf" veya ".docx" dahil!
  }) async {
    final uri = Uri.parse('http://localhost:7040/export');

    final body = {
      'projectName': projectName,
      'baselineName': baselineName,
      'format': format,
    };

    if (wordStyle != null) {
      body['wordStyle'] = wordStyle;
    }

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception("❌ Export başarısız: ${response.statusCode}");
    }

    final blob = html.Blob([response.bodyBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..download = downloadFilename
      ..click();

    html.Url.revokeObjectUrl(url);
  }

}