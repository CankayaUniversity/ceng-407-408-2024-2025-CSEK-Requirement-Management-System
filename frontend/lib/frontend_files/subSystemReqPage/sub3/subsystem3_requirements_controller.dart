import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/frontend_files/loginpage/auth_service.dart';

import 'package:frontend/frontend_files/subSystemReqPage/sub3/subsystem3_requirements_controller.dart'
    as controller;

import '../../../backend/attributes/sub3_attribute/sub3_attribute_api_service.dart';
import '../../../backend/attributes/sub3_attribute/sub3_attribute_model.dart';
import '../../../backend/attributes/sub3_attribute/sub3_attribute_provider.dart';
import '../../../backend/changeLogs/subsystem3_requirements_change_log/changeLog_subsystem3_requirement_api_service.dart';
import '../../../backend/changeLogs/subsystem3_requirements_change_log/changeLog_subsystem3_requirement_model.dart';
import '../../../backend/headers/header_sub3req/header_sub3req_api_service.dart';
import '../../../backend/headers/header_sub3req/header_sub3req_model.dart';
import '../../../backend/headers/header_sub3req/header_sub3req_provider.dart';
import '../../../backend/subsystems/subsystem3_requirements/subsystem3_requirement_api_service.dart';
import '../../../backend/subsystems/subsystem3_requirements/subsystem3_requirement_model.dart';
import '../../../backend/subsystems/subsystem3_requirements/subsystem3_requirement_provider.dart';
import '../../../backend/system_requirements/system_requirement_model.dart';
import '../../../backend/system_requirements/system_requirement_provider.dart';
import '../../../backend/projects/selected_project_provider.dart';
import '../../../backend/projects/selected_project_provider.dart';
import 'package:frontend/backend/user_requirements/user_requirement_model.dart';
import '../../../backend/user_requirements/user_requirement_model.dart';
import '../../../backend/user_requirements/user_requirement_provider.dart';

import 'package:frontend/frontend_files/subSystemReqPage/SubsystemRequirementGraph.dart';

class Subsystem3RequirementsController {
  static Future<void> loadUserInfo(
    Function(String, List<String>) onLoaded,
  ) async {
    final info = await AuthService.getUserInfo();
    final userRoles = await AuthService.getUserRoles();
    onLoaded(info?['username'] ?? 'Bilinmiyor', userRoles);
  }

  static void showAddRequirementDialog(
    BuildContext context,
    WidgetRef ref,
    String username,
  ) {
    final selectedProject = ref.read(selectedProjectProvider);
    if (selectedProject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen önce bir proje seçin.')),
      );
      return;
    }
    final _descriptionController = TextEditingController();
    final currentList = ref.read(subsystem3RequirementListProvider).value ?? [];
    final systemRequirements =
        ref.read(systemRequirementListProvider).value ?? [];

    int maxIndex = 0;
    for (var item in currentList) {
      final match = RegExp(r'^GG-(\d+)').firstMatch(item.title);
      if (match != null) {
        final number = int.tryParse(match.group(1)!);
        if (number != null && number > maxIndex) {
          maxIndex = number;
        }
      }
    }
    final nextTitle = 'GG-${maxIndex + 1}';

    String? selectedSystemReqId;
    SystemReqModel? selectedSystemReq;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Yeni Güvenlik Gereksinimi Ekle"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Başlık: $nextTitle",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // Sistem gereksinimi seçim alanı
                  DropdownButtonFormField<SystemReqModel>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: "Sistem Gereksinimi Seç",
                    ),
                    items:
                        systemRequirements.map((req) {
                          return DropdownMenuItem<SystemReqModel>(
                            value: req,
                            child: Text(req.title),
                          );
                        }).toList(),
                    onChanged: (val) {
                      selectedSystemReq = val;
                      selectedSystemReqId = val?.id;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Açıklama'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  final description = _descriptionController.text.trim();
                  if (description.isEmpty || selectedSystemReqId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tüm alanlar doldurulmalı')),
                    );
                    return;
                  }

                  final newRequirement = Subsystem3ReqModel(
                    id: '',
                    title: nextTitle,
                    description: description,
                    createdBy: username,
                    flag: false,
                    systemRequirementId: selectedSystemReqId!,
                    projectId: selectedProject.id,
                  );

                  await Subsystem3RequirementApiService().createRequirement(
                    newRequirement,
                  );
                  ref.refresh(subsystem3RequirementListProvider);
                  Navigator.of(context).pop();
                },
                child: const Text("Ekle"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("İptal"),
              ),
            ],
          ),
    );
    ;
  }

  static void showDescriptionDialog(
    BuildContext context,
    WidgetRef ref,
    Subsystem3ReqModel req,
    bool canEdit,
    String username,
    List<Header_Sub3Req_Model> headers,
    List<Sub3AttributeModel> attributes,
  ) {
    final _descController = TextEditingController(text: req.description);
    // Get system requirements and the currently selected one
    final systemRequirements =
        ref.read(systemRequirementListProvider).value ?? [];
    SystemReqModel? selectedSystemReq = systemRequirements.firstWhere(
      (r) => r.id == req.systemRequirementId,
      orElse:
          () =>
              systemRequirements.isNotEmpty
                  ? systemRequirements.first
                  : SystemReqModel(
                    id: '',
                    title: 'Bağlı Değil',
                    description: '',
                    createdBy: '',
                    flag: false,
                    user_req_id: '',
                    projectId: '',
                  ),
    );
    String? selectedSystemReqId = selectedSystemReq.id;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(req.title),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  canEdit
                      ? TextField(
                        controller: _descController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          labelText: 'Açıklama',
                        ),
                      )
                      : Text(req.description),
                  if (canEdit) ...[
                    const SizedBox(height: 10),
                    DropdownButtonFormField<SystemReqModel>(
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: "Sistem Gereksinimi Seç",
                      ),
                      value: selectedSystemReq,
                      items:
                          systemRequirements.map((s) {
                            return DropdownMenuItem<SystemReqModel>(
                              value: s,
                              child: Text(s.title),
                            );
                          }).toList(),
                      onChanged: (val) {
                        selectedSystemReq = val;
                        selectedSystemReqId = val?.id;
                      },
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              if (canEdit)
                TextButton(
                  onPressed: () {
                    _showConfirmationDialog(
                      context,
                      "GÜNCELLEMEK İSTEDİĞİNİZE EMİN MİSİNİZ?",
                      () async {
                        final updatedReq = Subsystem3ReqModel(
                          id: req.id,
                          title: req.title,
                          description: _descController.text.trim(),
                          createdBy: req.createdBy,
                          flag: false,
                          systemRequirementId:
                              selectedSystemReqId ?? req.systemRequirementId,
                          projectId: req.projectId,
                        );

                        await createChangeLogForRequirement(
                          username: username,
                          req: req,
                          headers: headers,
                          attributes: attributes,
                          changeType: 'update',
                        );

                        await Subsystem3RequirementApiService()
                            .updateRequirement(updatedReq);
                        ref.refresh(subsystem3RequirementListProvider);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                  child: const Text("Güncelle"),
                ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Kapat"),
              ),
            ],
          ),
    );
  }

  static Future<void> createChangeLogForRequirement({
    required String username,
    required Subsystem3ReqModel req,
    required List<Header_Sub3Req_Model> headers,
    required List<Sub3AttributeModel> attributes,
    required String changeType,
  }) async {
    final relatedAttributes =
        attributes.where((a) => a.subsystem3Id == req.id).toList();
    final oldHeaderTitles = headers.map((h) => h.header ?? '').toList();
    final oldAttributeDescriptions =
        relatedAttributes.map((a) => a.description ?? '').toList();

    final changeLog = Subsystem3RequirementChangeLog(
      modifiedBy: username,
      oldTitle: req.title,
      oldDescription: req.description,
      requirementId: req.id,
      header: oldHeaderTitles,
      oldAttributeDescription: oldAttributeDescriptions,
      changeType: changeType,
      modifiedAt: DateTime.now(),
      projectId: req.projectId,
    );

    await Subsystem3RequirementChangeLogApiService().create(changeLog);
  }

  static Future<void> toggleFlag(Subsystem3ReqModel req, WidgetRef ref) async {
    final updatedReq = Subsystem3ReqModel(
      id: req.id,
      title: req.title,
      description: req.description,
      createdBy: req.createdBy,
      flag: !req.flag,
      systemRequirementId: req.systemRequirementId,
      projectId: req.projectId,
    );
    await Subsystem3RequirementApiService().updateRequirement(updatedReq);
    ref.refresh(subsystem3RequirementListProvider);
  }

  static Future<void> deleteRequirement(
    String username,
    Subsystem3ReqModel req,
    WidgetRef ref,
    List<Header_Sub3Req_Model> headers,
    List<Sub3AttributeModel> attributes,
  ) async {
    await createChangeLogForRequirement(
      username: username,
      req: req,
      headers: headers,
      attributes: attributes,
      changeType: 'delete',
    );

    await Subsystem3RequirementApiService().deleteRequirement(req.id);
    ref.refresh(subsystem3RequirementListProvider);
  }

  static void _showConfirmationDialog(
    BuildContext context,
    String message,
    VoidCallback onConfirmed,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Onayla"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Hayır"),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirmed();
                },
                icon: const Icon(Icons.check),
                label: const Text("Evet"),
              ),
            ],
          ),
    );
  }

  static void showAddHeaderDialog(
    BuildContext context,
    WidgetRef ref,
    String username,
  ) {
    final _headerController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Yeni Header Ekle"),
            content: TextField(
              controller: _headerController,
              decoration: const InputDecoration(labelText: "Header Adı"),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  final headerText = _headerController.text.trim();
                  if (headerText.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Header adı boş olamaz")),
                    );
                    return;
                  }

                  final newHeader = Header_Sub3Req_Model(header: headerText);

                  await HeaderSub3ApiService().createRequirement(newHeader);
                  ref.refresh(headerSub3ReqModelListProvider);
                  Navigator.of(context).pop();
                },
                child: const Text("Ekle"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("İptal"),
              ),
            ],
          ),
    );
  }

  static void showAttributeDialog(
    BuildContext context,
    WidgetRef ref,
    String subSystemRequirementId,
    String header,
    String username,
    String? existingDescription, {
    String? attributeId,
    required bool canEdit,
  }) {
    final _descController = TextEditingController(
      text: existingDescription ?? '',
    );
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              "Attribute ${existingDescription == null ? 'Ekle' : 'Güncelle'}",
            ),
            content:
                canEdit
                    ? TextField(
                      controller: _descController,
                      maxLines: null,
                      decoration: const InputDecoration(labelText: "Açıklama"),
                    )
                    : Text(existingDescription ?? "-"),
            actions: [
              if (canEdit)
                TextButton(
                  onPressed: () async {
                    final desc = _descController.text.trim();
                    if (desc.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Açıklama boş olamaz")),
                      );
                      return;
                    }

                    if (attributeId != null && attributeId.isNotEmpty) {
                      final updatedAttr = Sub3AttributeModel(
                        id: attributeId,
                        title: header,
                        subsystem3Id: subSystemRequirementId,
                        description: desc,
                      );
                      await Sub3AttributeApiService().updateRequirement(
                        updatedAttr,
                      );
                    } else {
                      final newAttr = Sub3AttributeModel(
                        id: null,
                        title: header,
                        subsystem3Id: subSystemRequirementId,
                        description: desc,
                      );
                      await Sub3AttributeApiService().createRequirement(
                        newAttr,
                      );
                    }

                    // Requirement'ı flag=false yap
                    final allRequirements =
                        ref.read(subsystem3RequirementListProvider).value ?? [];
                    final target = allRequirements.firstWhere(
                      (r) => r.id == subSystemRequirementId,
                      orElse:
                          () => Subsystem3ReqModel(
                            id: '',
                            title: '',
                            description: '',
                            createdBy: '',
                            flag: true,
                            systemRequirementId: '',
                            projectId: '',
                          ),
                    );

                    if (target.id.isNotEmpty) {
                      final updatedReq = Subsystem3ReqModel(
                        id: target.id,
                        title: target.title,
                        description: target.description,
                        createdBy: target.createdBy,
                        systemRequirementId: target.systemRequirementId,
                        flag: false,
                        projectId: target.projectId,
                      );

                      await Subsystem3RequirementApiService().updateRequirement(
                        updatedReq,
                      );

                      final allHeaders =
                          ref.read(headerSub3ReqModelListProvider).value ?? [];
                      final allAttributes =
                          ref.read(sub3AttributeListProvider).value ?? [];

                      await controller
                          .Subsystem3RequirementsController.createChangeLogForRequirement(
                        username: username,
                        req: target,
                        headers: allHeaders,
                        attributes: allAttributes,
                        changeType: 'update-attribute',
                      );
                    }

                    ref.refresh(sub3AttributeListProvider);
                    ref.refresh(subsystem3RequirementListProvider);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Kaydet"),
                ),

              if (canEdit && attributeId != null && attributeId.isNotEmpty)
                TextButton(
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: const Text("Attribute Sil"),
                            content: const Text(
                              "Attribute'ı silmek istediğinize emin misiniz?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("İptal"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Sil"),
                              ),
                            ],
                          ),
                    );

                    if (confirmed == true) {
                      final allRequirements =
                          ref.read(subsystem3RequirementListProvider).value ??
                          [];
                      final target = allRequirements.firstWhere(
                        (r) => r.id == subSystemRequirementId,
                        orElse:
                            () => Subsystem3ReqModel(
                              id: '',
                              title: '',
                              description: '',
                              createdBy: '',
                              flag: true,
                              systemRequirementId: '',
                              projectId: '',
                            ),
                      );

                      if (target.id.isNotEmpty) {
                        final updatedReq = Subsystem3ReqModel(
                          id: target.id,
                          title: target.title,
                          description: target.description,
                          createdBy: target.createdBy,
                          flag: false,
                          systemRequirementId: target.systemRequirementId,
                          projectId: target.projectId,
                        );

                        await Subsystem3RequirementApiService()
                            .updateRequirement(updatedReq);

                        final allHeaders =
                            ref.read(headerSub3ReqModelListProvider).value ??
                            [];
                        final allAttributes =
                            ref.read(sub3AttributeListProvider).value ?? [];

                        await controller
                            .Subsystem3RequirementsController.createChangeLogForRequirement(
                          username: username,
                          req: updatedReq,
                          headers: allHeaders,
                          attributes: allAttributes,
                          changeType: 'delete-attribute',
                        );
                      }

                      await Sub3AttributeApiService().deleteRequirement(
                        attributeId!,
                      );
                      ref.refresh(sub3AttributeListProvider);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Sil", style: TextStyle(color: Colors.red)),
                ),

              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("İptal"),
              ),
            ],
          ),
    );
  }

  void debugPrintHelper(String label, dynamic value) {
    if (kDebugMode) {
      final isNull = value == null;
      final isEmpty = value is String ? value.isEmpty : false;

      print(
        '🧪 $label => '
        'Value: $value | '
        'Is Null: $isNull | '
        'Is Empty: $isEmpty | '
        'Type: ${value.runtimeType}',
      );
    }
  }

  static void showDetailPopup(
    String username,
    BuildContext context,
    WidgetRef ref,
    Subsystem3ReqModel req,
    bool isAdmin,
    bool canEdit,
    List<Header_Sub3Req_Model> headers,
    List<Sub3AttributeModel> attributes,
    List<SystemReqModel> systemRequirements,
  ) {
    final userReqList = ref.read(userRequirementListProvider).value ?? [];
    final linkedSystemReq = systemRequirements.firstWhere(
      (u) => u.id == req.systemRequirementId,
      orElse:
          () => SystemReqModel(
            id: '',
            title: 'Bağlı Değil',
            description: '',
            createdBy: '',
            flag: false,
            user_req_id: '',
            projectId: '',
          ),
    );
    final linkedUserReq = userReqList.firstWhere(
      (u) => u.id == linkedSystemReq.user_req_id,
      orElse:
          () => UserReqModel(
            id: '',
            title: 'Bağlı Değil',
            description: '',
            createdBy: '',
            flag: false,
            projectId: '',
          ),
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(req.title),
            content: SizedBox(
              width: 500,
              height: 350,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Açıklama:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(req.description),
                    const SizedBox(height: 20),

                    /// Grafik entegrasyonu:
                    SubsystemRequirementGraph(
                      kgTitle: linkedUserReq.title,
                      sgTitle: linkedSystemReq.title,
                      subsystemTitles: [req.title],
                    ),

                    const SizedBox(height: 20),
                    if (canEdit)
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          showDescriptionDialog(
                            context,
                            ref,
                            req,
                            canEdit,
                            username,
                            headers,
                            attributes,
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text("Güncelle"),
                      ),
                    if (isAdmin)
                      TextButton.icon(
                        onPressed: () {
                          _showConfirmationDialog(
                            context,
                            "Silmek istediğinize emin misiniz?",
                            () async {
                              await deleteRequirement(
                                username,
                                req,
                                ref,
                                headers,
                                attributes,
                              );
                              Navigator.of(context).pop();
                            },
                          );
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text(
                          "Sil",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
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
}
