import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/frontend_files/ExportPage/export_controller.dart'
  as controller;
import 'package:frontend/frontend_files/custom_app_bar.dart';
import '../../backend/projects/selected_project_provider.dart';


class ExportPage extends ConsumerStatefulWidget {
  const ExportPage({super.key});

  @override
  ConsumerState<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends ConsumerState<ExportPage> {

  String? username;
  List<String> roles = [];

  List<String> baselines = [];

  @override
  void initState() {
    super.initState();
    _loadBaselines();
    controller.ExportController.loadUserInfo((u, r) {
      setState(() {
        username = u;
        roles = r;
      });
    });
  }

  void _loadBaselines() async {
    try {
      final fetched = await controller.ExportController.fetchBaselineList(ref);
      setState(() {
        baselines = fetched;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Baseline verileri alınamadı: $e")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final selectedProject = ref.watch(selectedProjectProvider);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: selectedProject == null
          ? const Center(child: Text("Lütfen önce bir proje seçin."))
          : Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Raporlama İşlemleri",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Alınan Baseline'lar",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (baselines.isEmpty)
                    const Center(
                        child: Text("📭 Henüz alınmış bir baseline yok."))
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: baselines.length,
                      itemBuilder: (context, index) {
                        final baseline = baselines[index];
                        final originalBaselineName = baseline;
                        return Card(
                          margin:
                          const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const Icon(Icons.file_copy),
                            title: Text(controller.ExportController
                                .formatBaselineName(baseline)),
                            trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16),
                            onTap: () async {
                              final selectedProject = ref.read(selectedProjectProvider);
                              if (selectedProject == null) return;

                              final result = await _getFileNameFromUser(context);
                              if (result == null) return;

                              final (fileName, format, wordStyle) = result;

                              await controller.ExportController.exportBaseline(
                                projectName: selectedProject.name,
                                baselineName: originalBaselineName,
                                format: format,
                                wordStyle: wordStyle,
                                fileName: fileName,
                              );
                            },
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormatTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Future<(String fileName, String format, String? wordStyle)?> _getFileNameFromUser(BuildContext context) async {
    final TextEditingController nameController = TextEditingController();
    String selectedFormat = 'pdf';
    String selectedWordStyle = 'table';

    return showDialog<(String, String, String?)>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Dosya Bilgileri"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Dosya adı (uzantı olmadan)"),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedFormat,
                    items: const [
                      DropdownMenuItem(value: 'pdf', child: Text('PDF')),
                      DropdownMenuItem(value: 'word', child: Text('Word')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedFormat = value;
                        });
                      }
                    },
                    decoration: const InputDecoration(labelText: "Format"),
                  ),
                  if (selectedFormat == 'word') ...[
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedWordStyle,
                      items: const [
                        DropdownMenuItem(value: 'table', child: Text('Table')),
                        DropdownMenuItem(value: 'document', child: Text('Document')),
                        DropdownMenuItem(value: 'book', child: Text('Book')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedWordStyle = value;
                          });
                        }
                      },
                      decoration: const InputDecoration(labelText: "Word Stili"),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  child: const Text("İptal"),
                  onPressed: () => Navigator.of(context).pop(null),
                ),
                ElevatedButton(
                  child: const Text("Devam"),
                  onPressed: () {
                    final fileName = nameController.text.trim();
                    if (fileName.isEmpty) return;

                    final format = selectedFormat;
                    final style = format == 'word' ? selectedWordStyle : null;
                    final fullName = '$fileName.${format == 'pdf' ? 'pdf' : 'docx'}';
                    Navigator.of(context).pop((fullName, format, style));
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }


}