import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/backend/projects/selected_project_provider.dart';
import '../../../backend/changeLogs/changeLog_requirement_interface_model.dart';
import '../../../backend/changeLogs/user_requirements_change_log/changeLog_user_requirement_provider.dart';
import '../../../backend/changeLogs/system_requirements_change_log/changeLog_system_requirement_provider.dart';
import '../../../backend/changeLogs/subsystem1_requirements_change_log/changeLog_subsystem1_requirement_provider.dart';
import '../../../backend/changeLogs/subsystem2_requirements_change_log/changeLog_subsystem2_requirement_provider.dart';
import '../../../backend/changeLogs/subsystem3_requirements_change_log/changeLog_subsystem3_requirement_provider.dart';
import 'change_log_controller.dart' as controller;
import 'package:frontend/frontend_files/custom_app_bar.dart';

class ChangeLogPage extends ConsumerStatefulWidget {
  const ChangeLogPage({super.key});

  @override
  ConsumerState<ChangeLogPage> createState() => _ChangeLogPageState();
}

class _ChangeLogPageState extends ConsumerState<ChangeLogPage> {
  String? username;
  List<String> roles = [];
  TextEditingController titleFilterController = TextEditingController();
  TextEditingController titleSearchController = TextEditingController();
  String? selectedChangeType;
  String? selectedModifiedBy;
  DateTime? startDate;
  DateTime? endDate;
  String? selectedPrefix;

  @override
  void initState() {
    super.initState();
    controller.ChangeLogController.loadUserInfo((u, r) {
      setState(() {
        username = u;
        roles = r;
      });
    });
  }

  @override
  void dispose() {
    titleFilterController.dispose();
    titleSearchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(
      () => ref.invalidate(userRequirementChangeLogListProvider),
    );
    Future.microtask(
      () => ref.invalidate(systemRequirementChangeLogListProvider),
    );
    Future.microtask(
      () => ref.invalidate(subsystem1RequirementChangeLogListProvider),
    );
    Future.microtask(
      () => ref.invalidate(subsystem2RequirementChangeLogListProvider),
    );
    Future.microtask(
      () => ref.invalidate(subsystem3RequirementChangeLogListProvider),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = roles.contains('admin');
    final isSystemEngineer = roles.contains('system_engineer');

    if (!isAdmin && !isSystemEngineer) {
      return const Scaffold(
        appBar: CustomAppBar(),
        body: Center(child: Text("Bu sayfayı görüntüleme izniniz yok.")),
      );
    }
    final selectedProject = ref.watch(selectedProjectProvider);
    if (selectedProject == null) {
      return const Scaffold(
        appBar: CustomAppBar(),
        body: Center(
          child: Text(
            'Lütfen önce bir proje seçin.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    final selectedProjectId = selectedProject?.id;
    final changeLogUserReqAsync = ref.watch(
      userRequirementChangeLogListProvider,
    );
    final changeLogSystemReqAsync = ref.watch(
      systemRequirementChangeLogListProvider,
    );
    final changeLogSub1ReqAsync = ref.watch(
      subsystem1RequirementChangeLogListProvider,
    );
    final changeLogSub2ReqAsync = ref.watch(
      subsystem2RequirementChangeLogListProvider,
    );
    final changeLogSub3ReqAsync = ref.watch(
      subsystem3RequirementChangeLogListProvider,
    );

    if (changeLogUserReqAsync.isLoading ||
        changeLogSystemReqAsync.isLoading ||
        changeLogSub1ReqAsync.isLoading ||
        changeLogSub2ReqAsync.isLoading ||
        changeLogSub3ReqAsync.isLoading) {
      return const Scaffold(
        appBar: CustomAppBar(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (changeLogUserReqAsync.hasError ||
        changeLogSystemReqAsync.hasError ||
        changeLogSub1ReqAsync.hasError ||
        changeLogSub2ReqAsync.hasError ||
        changeLogSub3ReqAsync.hasError) {
      return const Scaffold(
        appBar: CustomAppBar(),
        body: Center(child: Text("Hata: Veriler yüklenemedi")),
      );
    }

    final List<RequirementChangeLog> allLogs = [
      ...changeLogUserReqAsync.value ?? [],
      ...changeLogSystemReqAsync.value ?? [],
      ...changeLogSub1ReqAsync.value ?? [],
      ...changeLogSub2ReqAsync.value ?? [],
      ...changeLogSub3ReqAsync.value ?? [],
    ];

    final filteredLogs = controller.ChangeLogController.filterLogs(
      logs: allLogs,
      prefix: selectedPrefix,
      selectedProjectId: selectedProjectId,
      changeType: selectedChangeType,
      modifiedBy: selectedModifiedBy,
      startDate: startDate,
      endDate: endDate,
      exactTitle: titleSearchController.text.trim(),
    );

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 16,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 140,
                    child: DropdownButton<String>(
                      hint: const Text("Gereksinim Tipi"),
                      value: selectedPrefix,
                      onChanged:
                          (value) => setState(() => selectedPrefix = value),
                      items:
                          ['KG', 'SG', 'DG', 'YG', 'GG']
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ),
                              )
                              .toList(),
                    ),
                  ),

                  SizedBox(
                    width: 140,
                    child: TextField(
                      enabled: selectedPrefix != null,
                      controller: titleSearchController,
                      decoration: InputDecoration(
                        labelText: "Gereksinim Tipi",
                        hintText:
                            selectedPrefix == null ? "Önce tip seçin" : null,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),

                  // Değişiklik tipi
                  DropdownButton<String>(
                    hint: const Text("Değiştirilme Tipi"),
                    value: selectedChangeType,
                    onChanged:
                        (value) => setState(() => selectedChangeType = value),
                    items:
                        [
                              'update',
                              'delete',
                              'update-attribute',
                              'delete-attribute',
                            ]
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ),
                            )
                            .toList(),
                  ),

                  // Değiştiren
                  DropdownButton<String>(
                    hint: const Text("Değiştiren"),
                    value: selectedModifiedBy,
                    onChanged:
                        (value) => setState(() => selectedModifiedBy = value),
                    items:
                        allLogs
                            .map((e) => e.modifiedBy ?? "")
                            .toSet()
                            .map<DropdownMenuItem<String>>(
                              (name) => DropdownMenuItem<String>(
                                value: name,
                                child: Text(name),
                              ),
                            )
                            .toList(),
                  ),

                  // Başlangıç tarihi
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          startDate = picked;
                        });
                      }
                    },
                    child: Text(
                      "Başlangıç: ${startDate != null ? startDate!.toLocal().toString().split(' ')[0] : 'Seç'}",
                    ),
                  ),

                  // Bitiş tarihi
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          endDate = picked;
                        });
                      }
                    },
                    child: Text(
                      "Bitiş: ${endDate != null ? endDate!.toLocal().toString().split(' ')[0] : 'Seç'}",
                    ),
                  ),

                  // Temizle
                  TextButton(
                    onPressed: () {
                      selectedPrefix = null;
                      titleFilterController.clear();
                      titleSearchController.clear();
                      selectedChangeType = null;
                      selectedModifiedBy = null;
                      startDate = null;
                      endDate = null;
                      setState(() {});
                    },
                    child: const Text("Temizle"),
                  ),
                ],
              ),
            ),
          ),

          const Divider(),

          Expanded(
            child: ListView.builder(
              itemCount: filteredLogs.length,
              itemBuilder: (context, index) {
                final log = filteredLogs[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: GestureDetector(
                    onTap: () => showLogDetailsDialog(context, log),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            width: 150,
                            color: Colors.grey[400],
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  log.oldTitle ?? 'Başlık Yok',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  log.changeType?.toUpperCase() ?? '',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        log.changeType == 'delete'
                                            ? Colors.red.shade600
                                            : Colors.blue.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            width: 500,
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              log.oldDescription ?? '-',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          Container(
                            width: 150,
                            padding: const EdgeInsets.all(12),
                            child: Text(log.modifiedBy ?? '-'),
                          ),
                          Container(
                            width: 200,
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              log.modifiedAt?.toLocal().toString().split(
                                    '.',
                                  )[0] ??
                                  '-',
                            ),
                          ),

                          // Header ve Attribute eşleşmeleri
                          ...List.generate(log.header?.length ?? 0, (i) {
                            final headerText = log.header?[i] ?? '-';
                            final attributeText =
                                (log.oldAttributeDescription?.length ?? 0) > i
                                    ? log.oldAttributeDescription![i]
                                    : '-';

                            return Container(
                              width: 150,
                              padding: const EdgeInsets.all(12),
                              child: Tooltip(
                                message: '$headerText',
                                child: Text(
                                  attributeText.length > 20
                                      ? '${attributeText.substring(0, 20)}...'
                                      : attributeText,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void showLogDetailsDialog(BuildContext context, RequirementChangeLog log) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(log.oldTitle ?? 'Gereksinim'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Değişiklik Tipi: ${log.changeType?.toUpperCase() ?? '-'}",
                  ),
                  Text("Yapan: ${log.modifiedBy ?? '-'}"),
                  Text(
                    "Tarih: ${log.modifiedAt?.toLocal().toString().split('.')[0] ?? '-'}",
                  ),
                  const SizedBox(height: 12),

                  Text(
                    "Açıklama:",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(log.oldDescription ?? '-'),
                  const SizedBox(height: 12),

                  if ((log.header?.isNotEmpty ?? false) &&
                      (log.oldAttributeDescription?.isNotEmpty ?? false))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(log.header!.length, (i) {
                        final h = log.header?[i] ?? '-';
                        final desc =
                            (log.oldAttributeDescription?.length ?? 0) > i
                                ? log.oldAttributeDescription![i]
                                : '-';
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$h: ",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(child: Text(desc)),
                            ],
                          ),
                        );
                      }),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Kapat"),
              ),
            ],
          ),
    );
  }
}
