import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/frontend_files/BaselinePage/baseline_controller.dart'
    as controller;
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
      builder:
          (_) => AlertDialog(
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
                    builder:
                        (_) => AlertDialog(
                          title: const Text("Emin misiniz?"),
                          content: const Text(
                            "Baseline işlemi başlatılacak. Devam edilsin mi?",
                          ),
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

  void showBaselineListDialog(
    BuildContext context,
    WidgetRef ref,
    String username,
  ) {
    final selectedProject = ref.read(selectedProjectProvider);
    if (selectedProject == null) return;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Alınan Baseline'lar"),
            content: SizedBox(
              width: 500,
              height: 300,
              child: ListView.builder(
                itemCount: baselines.length,
                itemBuilder: (context, index) {
                  final baselineName = baselines[index];
                  return ListTile(
                    title: Text(
                      controller.SnapshotController.formatBaselineName(
                        baselineName,
                      ),
                    ),
                    onTap: () async {
                      try {
                        final snapshotData = await controller
                            .SnapshotController.fetchSnapshotContent(
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
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text("Hata: $e")));
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

  void showSnapshotDetailDialog(
    BuildContext context,
    Map<String, dynamic> snapshotData,
  ) {
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
                  Text(
                    "📁 Proje: $projectName",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("📦 Versiyon: $baselineName"),
                  Text("🕒 Zaman: $timestamp"),
                  Text("👤 Oluşturan: $username"),
                  const Divider(),
                  const SizedBox(height: 8),
                  ...desiredModuleOrder
                      .where((key) => snapshotData.containsKey(key))
                      .map((moduleKey) {
                        final displayName =
                            moduleOptions.entries
                                .firstWhere(
                                  (e) => e.value == moduleKey,
                                  orElse: () => MapEntry(moduleKey, moduleKey),
                                )
                                .key;
                        final jsonContent = snapshotData[moduleKey];

                        return ExpansionTile(
                          title: Text(displayName),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: buildModuleContent(
                                moduleKey,
                                jsonContent,
                                snapshotData,
                              ),
                            ),
                          ],
                        );
                      })
                      .toList(),
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
                  builder:
                      (context, setState) => Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: baselines.length,
                              itemBuilder: (context, index) {
                                final name = baselines[index];
                                return CheckboxListTile(
                                  title: Text(
                                    controller
                                        .SnapshotController.formatBaselineName(
                                      name,
                                    ),
                                  ),
                                  value: selected.contains(name),
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true &&
                                          selected.length < 2) {
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
                                onPressed:
                                    () => Navigator.of(dialogContext).pop(),
                                child: const Text("İptal"),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed:
                                    selected.length == 2
                                        ? () async {
                                          final b1 = selected[0];
                                          final b2 = selected[1];
                                          final parentContext =
                                              Navigator.of(context).context;

                                          Navigator.of(dialogContext).pop();

                                          try {
                                            final result = await controller
                                                .SnapshotController.fetchComparison(
                                              projectName: selectedProject.name,
                                              baseline1: b1,
                                              baseline2: b2,
                                            );

                                            showComparisonResultDialog(
                                              parentContext,
                                              result,
                                            );
                                          } catch (e) {
                                            showDialog(
                                              context: parentContext,
                                              builder:
                                                  (_) => AlertDialog(
                                                    title: const Text("Hata"),
                                                    content: Text(
                                                      "Karşılaştırma alınamadı: $e",
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed:
                                                            () =>
                                                                Navigator.of(
                                                                  parentContext,
                                                                ).pop(),
                                                        child: const Text(
                                                          "Tamam",
                                                        ),
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
                          ),
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

  void showComparisonResultDialog(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    List<Map<String, dynamic>> parseList(dynamic raw) {
      try {
        if (raw is List) {
          return raw
              .where((e) => e is Map)
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
        }
        if (raw is String) {
          final decoded = jsonDecode(raw);
          if (decoded is List) {
            return decoded
                .where((e) => e is Map)
                .map((e) => Map<String, dynamic>.from(e))
                .toList();
          }
        }
      } catch (e) {
        print('parseList HATA: $e');
      }
      return [];
    }

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  width: 650,
                  height: 550,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24, width: 1),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Karşılaştırma Sonucu",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children:
                                desiredModuleOrder.where((key) => data.containsKey(key)).map((
                                  moduleKey,
                                ) {
                                  final rawValue = data[moduleKey];
                                  Map<String, dynamic> value;

                                  if (rawValue is String) {
                                    try {
                                      value = jsonDecode(rawValue);
                                    } catch (e) {
                                      value = {};
                                      print('jsonDecode hatası: $e');
                                    }
                                  } else if (rawValue is Map<String, dynamic>) {
                                    value = rawValue;
                                  } else {
                                    value = {};
                                  }

                                  final added = parseList(value["added"]);
                                  final removed = parseList(value["removed"]);
                                  final updated = parseList(value["updated"]);

                                  final displayName =
                                      moduleOptions.entries
                                          .firstWhere(
                                            (e) => e.value == moduleKey,
                                            orElse:
                                                () => MapEntry(
                                                  moduleKey,
                                                  moduleKey,
                                                ),
                                          )
                                          .key;

                                  final hasChanges =
                                      added.isNotEmpty ||
                                      removed.isNotEmpty ||
                                      updated.isNotEmpty;

                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2A2A2A),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Theme(
                                      data: ThemeData().copyWith(
                                        dividerColor: Colors.transparent,
                                      ),
                                      child: ExpansionTile(
                                        collapsedIconColor: Colors.white70,
                                        iconColor: Colors.white,
                                        title: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            displayName,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        children:
                                            hasChanges
                                                ? [
                                                  if (added.isNotEmpty) ...[
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 6,
                                                            ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: const [
                                                            Icon(
                                                              Icons.add_circle,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            SizedBox(width: 6),
                                                            Text(
                                                              "Eklenenler",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white70,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    ...added.map(
                                                      (e) => Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              left: 20,
                                                              top: 4,
                                                            ),
                                                        child: Align(
                                                          alignment:
                                                              Alignment
                                                                  .centerLeft,
                                                          child: Text(
                                                            "- ${e['title']}: ${e['description']}",
                                                            style:
                                                                const TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  if (removed.isNotEmpty) ...[
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 6,
                                                            ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: const [
                                                            Icon(
                                                              Icons
                                                                  .remove_circle,
                                                              color:
                                                                  Colors
                                                                      .redAccent,
                                                            ),
                                                            SizedBox(width: 6),
                                                            Text(
                                                              "Kaldırılanlar",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white70,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    ...removed.map(
                                                      (e) => Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              left: 20,
                                                              top: 4,
                                                            ),
                                                        child: Align(
                                                          alignment:
                                                              Alignment
                                                                  .centerLeft,
                                                          child: Text(
                                                            "- ${e['title']}: ${e['description']}",
                                                            style:
                                                                const TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  if (updated.isNotEmpty) ...[
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 6,
                                                            ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: const [
                                                            Icon(
                                                              Icons.update,
                                                              color:
                                                                  Colors
                                                                      .amberAccent,
                                                            ),
                                                            SizedBox(width: 6),
                                                            Text(
                                                              "Güncellenenler",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white70,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    ...updated.map(
                                                      (e) => Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              left: 20,
                                                              top: 4,
                                                            ),
                                                        child: Align(
                                                          alignment:
                                                              Alignment
                                                                  .centerLeft,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "• ${e['before']['title']}",
                                                                style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                ),
                                                              ),
                                                              Text(
                                                                "  - Önce: ${e['before']['description']}",
                                                                style: const TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .white70,
                                                                ),
                                                              ),
                                                              Text(
                                                                "  - Sonra: ${e['after']['description']}",
                                                                style: const TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .white70,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ]
                                                : [
                                                  const Padding(
                                                    padding: EdgeInsets.all(
                                                      12.0,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.balance,
                                                          color:
                                                              Colors.blueGrey,
                                                        ),
                                                        SizedBox(width: 6),
                                                        Text(
                                                          "Bu modülde değişiklik yok.",
                                                          style: TextStyle(
                                                            color:
                                                                Colors.white70,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close, color: Colors.white70),
                          label: const Text(
                            "Kapat",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  Widget buildSectionTitle(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget buildEntryText(Map<String, dynamic> e) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 4),
      child: Text(
        "- ${e['title']}: ${e['description']}",
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedProject = ref.watch(selectedProjectProvider);

    return Scaffold(
      appBar: const CustomAppBar(),
      body:
          selectedProject == null
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
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
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
                                  showBaselineListDialog(
                                    context,
                                    ref,
                                    username!,
                                  );
                                },
                              );
                            }, // ...
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.compare_arrows),
                            title: const Text("Baseline Karşılaştır"),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap:
                                () => showBaselineCompareDialog(context, ref),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
    );
  }

  Widget buildModuleContent(
    String moduleKey,
    Map<String, dynamic> jsonContent,
    Map<String, dynamic> snapshotData,
  ) {
    final requirements = jsonContent['requirements'] as List<dynamic>? ?? [];
    final attributes = jsonContent['attributes'] as List<dynamic>? ?? [];
    final headers = jsonContent['headers'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...requirements.map((req) {
          final reqId = req['id'];
          final reqAttributes =
              attributes.where((attr) {
                final keys = attr.keys;
                final matchingKey = keys.firstWhere(
                  (key) => key.toLowerCase().contains('id') && key != 'id',
                  orElse: () => '',
                );
                return attr[matchingKey] == reqId;
              }).toList();

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "🎯 ${req['title']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("📝 ${req['description']}"),
                  Text("👤 Oluşturan: ${req['createdBy']}"),
                  if (moduleKey != 'user-requirements') ...[
                    const SizedBox(height: 4),
                    Builder(
                      builder: (context) {
                        final linkedId =
                            req['user_req_id'] ?? req['systemRequirementId'];
                        final linkedTitle = controller
                            .SnapshotController.findRequirementTitleById(
                          snapshotData,
                          linkedId,
                        );
                        return Text(
                          "🔗 Bağlı Olduğu Gereksinim: ${linkedTitle ?? linkedId}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 6),
                  if (reqAttributes.isNotEmpty) const Divider(),
                  ...reqAttributes.map(
                    (attr) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Text(
                        "🔹 ${attr['title'] ?? attr['header']}: ${attr['description']}",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
