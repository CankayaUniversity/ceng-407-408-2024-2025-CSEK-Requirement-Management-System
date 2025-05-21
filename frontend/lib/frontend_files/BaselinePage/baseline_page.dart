import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/frontend_files/BaselinePage/baseline_controller.dart' as controller;
import 'package:frontend/frontend_files/custom_app_bar.dart';

import '../../backend/projects/selected_project_provider.dart';

class SnapshotPage extends ConsumerStatefulWidget {
  const SnapshotPage({super.key});
  @override
  ConsumerState<SnapshotPage> createState() => _SnapshotPageState();
}

class _SnapshotPageState extends ConsumerState<SnapshotPage> {

  final Map<String, String> moduleOptions = {
    "KULLANICI-GEREKSİNİMLERİ": "user-requirements",
    "SİSTEM-GEREKSİNİMLERİ": "system-requirements",
    "DONANIM-GEREKSİNİMLERİ": "subsystem1-requirements",
    "YAZILIM-GEREKSİNİMLERİ": "subsystem2-requirements",
    "GÜVENLİK-GEREKSİNİMLERİ": "subsystem3-requirements",
  };

  final List<String> desiredModuleOrder = [
    "user-requirements",
    "system-requirements",
    "subsystem1-requirements",
    "subsystem2-requirements",
    "subsystem3-requirements",
  ];

  String? username;
  List<String> roles = [];

  List<String> baselines = [];

  @override
  void initState() {
    super.initState();
    controller.SnapshotController.loadUserInfo((u, r) {
      setState(() {
        username = u;
        roles = r;
      });
    });
  }


  void showBaselineDialog(BuildContext context) {
    final descriptionController = TextEditingController();
    final selectedModules = <String>{};
    final modules = [
      'KULLANICI-GEREKSİNİMLERİ',
      'SİSTEM-GEREKSİNİMLERİ',
      'DONANIM-GEREKSİNİMLERİ',
      'YAZILIM-GEREKSİNİMLERİ',
      'GÜVENLİK-GEREKSİNİMLERİ',
    ];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Baseline Al"),
        content: SizedBox(
          width: 500,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Versiyon Adı',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Modülleri seçin:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...moduleOptions.keys.map((label) {
                    final value = moduleOptions[label]!;
                    return CheckboxListTile(
                      title: Text(label),
                      value: selectedModules.contains(value),
                      onChanged: (isSelected) {
                        setState(() {
                          if (isSelected == true) {
                            selectedModules.add(value);
                          } else {
                            selectedModules.remove(value);
                          }
                        });
                      },
                    );
                  }).toList(),
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal"),
          ),
          TextButton(
            onPressed: () async {
              final desc = descriptionController.text.trim();
              if (desc.isEmpty || selectedModules.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Açıklama girin ve en az 1 modül seçin."),
                  ),
                );
                return;
              }

              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Emin misiniz?"),
                  content:
                  const Text("Baseline işlemi başlatılacak. Devam edilsin mi?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Vazgeç"),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Evet, başla"),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                Navigator.pop(context);
                await controller.SnapshotController.sendSnapshotRequests(
                  context: context,
                  ref: ref,
                  username: username!,
                  selectedModules: selectedModules.toList(),
                  description: desc,
                );
                Navigator.pop(context);
              }
            },
            child: const Text("Baseline Oluştur"),
          ),
        ],
      ),
    );
  }

  void showBaselineListDialog(BuildContext context, WidgetRef ref, String username) {
    final selectedProject = ref.read(selectedProjectProvider);
    if (selectedProject == null) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Alınan Baseline'lar"),
        content: SizedBox(
          width: 500,
          height: 300,
          child: ListView.builder(
            itemCount: baselines.length,
            itemBuilder: (context, index) {
              final baselineName = baselines[index];
              return ListTile(
                title: Text(controller.SnapshotController.formatBaselineName(baselineName)),
                onTap: () async {
                  try {
                    final snapshotData = await controller.SnapshotController.fetchSnapshotContent(
                      projectName: selectedProject.name,
                      baselineName: baselineName,
                    );

                    if (context.mounted) {
                      Navigator.of(context).pop();
                      await Future.delayed(Duration(milliseconds: 50));
                      showSnapshotDetailDialog(context, snapshotData);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Hata: $e")),
                      );
                    }
                  }
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Kapat"),
          ),
        ],
      ),
    );
  }

  void showSnapshotDetailDialog(BuildContext context, Map<String, dynamic> snapshotData) {
    final infoRaw = snapshotData["baseline-info"];
    final info = infoRaw is String ? jsonDecode(infoRaw) : infoRaw;

    final baselineName = info?["baselineName"] ?? "Bilinmiyor";
    final projectName = info?["projectName"] ?? "-";
    final timestamp = info?["timestamp"] ?? "-";
    final username = info?["username"] ?? "-";

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Baseline Detayı"),
          content: SizedBox(
            width: 600,
            height: 500,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("📁 Proje: $projectName",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("📦 Versiyon: $baselineName"),
                  Text("🕒 Zaman: $timestamp"),
                  Text("👤 Oluşturan: $username"),
                  const Divider(),
                  const SizedBox(height: 8),
                  ...desiredModuleOrder
                      .where((key) => snapshotData.containsKey(key))
                      .map((moduleKey) {
                    final displayName = moduleOptions.entries
                        .firstWhere((e) => e.value == moduleKey, orElse: () => MapEntry(moduleKey, moduleKey))
                        .key;
                    final jsonContent = snapshotData[moduleKey];


                    return ExpansionTile(
                      title: Text(displayName),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildModuleContent(moduleKey, jsonContent, snapshotData),
                        ),
                      ],
                    );

                  }).toList(),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("Kapat"),
            ),
          ],
        );
      },
    );
  }

  void showBaselineCompareDialog(BuildContext context, WidgetRef ref) {
    final selectedProject = ref.read(selectedProjectProvider);
    if (selectedProject == null) return;

    controller.SnapshotController.fetchBaselines(
      context: context,
      ref: ref,
      onLoaded: (List<String> baselines) {
        showDialog(
          context: context,
          builder: (dialogContext) {
            List<String> selected = [];

            return AlertDialog(
              title: const Text("Karşılaştırılacak Baseline'ları Seç"),
              content: SizedBox(
                width: 500,
                height: 400,
                child: StatefulBuilder(
                  builder: (context, setState) => Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: baselines.length,
                          itemBuilder: (context, index) {
                            final name = baselines[index];
                            return CheckboxListTile(
                              title: Text(controller.SnapshotController.formatBaselineName(name)),
                              value: selected.contains(name),
                              onChanged: (value) {
                                setState(() {
                                  if (value == true && selected.length < 2) {
                                    selected.add(name);
                                  } else {
                                    selected.remove(name);
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            child: const Text("İptal"),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: selected.length == 2
                                ? () async {
                              final b1 = selected[0];
                              final b2 = selected[1];
                              final parentContext = Navigator.of(context).context;

                              Navigator.of(dialogContext).pop();

                              try {
                                final result = await controller.SnapshotController.fetchComparison(
                                  projectName: selectedProject.name,
                                  baseline1: b1,
                                  baseline2: b2,
                                );

                                showComparisonResultDialog(parentContext, result);
                              } catch (e) {
                                showDialog(
                                  context: parentContext,
                                  builder: (_) => AlertDialog(
                                    title: const Text("Hata"),
                                    content: Text("Karşılaştırma alınamadı: $e"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(parentContext).pop(),
                                        child: const Text("Tamam"),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                                : null,
                            child: const Text("Karşılaştır"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }


  void showComparisonResultDialog(BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Karşılaştırma Sonucu"),
        content: SizedBox(
          width: 600,
          height: 500,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: desiredModuleOrder
                  .where((key) => data.containsKey(key))
                  .map((moduleKey) {
                final value = data[moduleKey];

                final added = value["added"] as List<dynamic>;
                final removed = value["removed"] as List<dynamic>;
                final updated = value["updated"] as List<dynamic>;

                final displayName = moduleOptions.entries
                    .firstWhere((e) => e.value == moduleKey,
                    orElse: () => MapEntry(moduleKey, moduleKey))
                    .key;

                final hasChanges =
                    added.isNotEmpty || removed.isNotEmpty || updated.isNotEmpty;

                return ExpansionTile(
                  title: Text(displayName),
                  children: hasChanges
                      ? [
                    if (added.isNotEmpty) ...[
                      const Text("➕ Eklenenler:"),
                      ...added.map((e) =>
                          Text("- ${e['title']}: ${e['description']}")),
                    ],
                    if (removed.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      const Text("➖ Kaldırılanlar:"),
                      ...removed.map((e) =>
                          Text("- ${e['title']}: ${e['description']}")),
                    ],
                    if (updated.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      const Text("🔄 Güncellenenler:"),
                      ...updated.map((e) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• ${e['before']['title']}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          Text(
                              "  - Önce: ${e['before']['description']}"),
                          Text(
                              "  - Sonra: ${e['after']['description']}"),
                        ],
                      )),
                    ],
                  ]
                      : [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("⚖️ Bu modülde değişiklik yok."),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Kapat"),
          ),
        ],
      ),
    );
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
                    "Baseline İşlemleri",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text("Baseline Al"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => showBaselineDialog(context),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.list_alt),
                    title: const Text("Alınan Baseline'lar"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      controller.SnapshotController.fetchBaselines(
                        context: context,
                        ref: ref,
                        onLoaded: (data) {
                          setState(() {
                            baselines = data;
                          });
                          showBaselineListDialog(context, ref, username!);
                        },
                      );
                    },// ...
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.compare_arrows),
                    title: const Text("Baseline Karşılaştır"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => showBaselineCompareDialog(context, ref),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildModuleContent(String moduleKey, Map<String, dynamic> jsonContent, Map<String, dynamic> snapshotData) {
    final requirements = jsonContent['requirements'] as List<dynamic>? ?? [];
    final attributes = jsonContent['attributes'] as List<dynamic>? ?? [];
    final headers = jsonContent['headers'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...requirements.map((req) {
          final reqId = req['id'];
          final reqAttributes = attributes.where((attr) {
            final keys = attr.keys;
            final matchingKey = keys.firstWhere(
                    (key) => key.toLowerCase().contains('id') && key != 'id',
                orElse: () => '');
            return attr[matchingKey] == reqId;
          }).toList();

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("🎯 ${req['title']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("📝 ${req['description']}"),
                  Text("👤 Oluşturan: ${req['createdBy']}"),
                  if (moduleKey != 'user-requirements') ...[
                    const SizedBox(height: 4),
                    Builder(builder: (context) {
                      final linkedId = req['user_req_id'] ?? req['systemRequirementId'];
                      final linkedTitle = controller.SnapshotController.findRequirementTitleById(snapshotData, linkedId);
                      return Text(
                        "🔗 Bağlı Olduğu Gereksinim: ${linkedTitle ?? linkedId}",
                        style: const TextStyle(fontSize: 12,color: Colors.grey),
                      );
                    }),
                  ],
                  const SizedBox(height: 6),
                  if (reqAttributes.isNotEmpty) const Divider(),
                  ...reqAttributes.map((attr) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text("🔹 ${attr['title'] ?? attr['header']}: ${attr['description']}"),
                  )),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }


}