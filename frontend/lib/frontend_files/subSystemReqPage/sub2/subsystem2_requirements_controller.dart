import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/frontend_files/loginpage/auth_service.dart';

import 'package:frontend/frontend_files/subSystemReqPage/sub2/subsystem2_requirements_controller.dart'
    as controller;

import '../../../backend/attributes/sub2_attribute/sub2_attribute_api_service.dart';
import '../../../backend/attributes/sub2_attribute/sub2_attribute_model.dart';
import '../../../backend/attributes/sub2_attribute/sub2_attribute_provider.dart';
import '../../../backend/changeLogs/subsystem2_requirements_change_log/changeLog_subsystem2_requirement_api_service.dart';
import '../../../backend/changeLogs/subsystem2_requirements_change_log/changeLog_subsystem2_requirement_model.dart';
import '../../../backend/headers/header_sub2req/header_sub2req_api_service.dart';
import '../../../backend/headers/header_sub2req/header_sub2req_model.dart';
import '../../../backend/headers/header_sub2req/header_sub2req_provider.dart';
import '../../../backend/subsystems/subsystem2_requirements/subsystem2_requirement_api_service.dart';
import '../../../backend/subsystems/subsystem2_requirements/subsystem2_requirement_model.dart';
import '../../../backend/subsystems/subsystem2_requirements/subsystem2_requirement_provider.dart';
import '../../../backend/system_requirements/system_requirement_model.dart';
import '../../../backend/system_requirements/system_requirement_provider.dart';
import '../../../backend/projects/selected_project_provider.dart';

class Subsystem2RequirementsController {
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
    final currentList = ref.read(subsystem2RequirementListProvider).value ?? [];
    final systemRequirements =
        ref.read(systemRequirementListProvider).value ?? [];

    int maxIndex = 0;
    for (var item in currentList) {
      final match = RegExp(r'^YG-(\d+)').firstMatch(item.title);
      if (match != null) {
        final number = int.tryParse(match.group(1)!);
        if (number != null && number > maxIndex) {
          maxIndex = number;
        }
      }
    }
    final nextTitle = 'YG-${maxIndex + 1}';

    String? selectedSystemReqId;
    SystemReqModel? selectedSystemReq;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Yeni Yazılım Gereksinimi Ekle"),
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

                  final newRequirement = Subsystem2ReqModel(
                    id: '',
                    title: nextTitle,
                    description: description,
                    createdBy: username,
                    flag: false,
                    systemRequirementId: selectedSystemReqId!,
                    projectId: selectedProject.id,
                  );

                  await Subsystem2RequirementApiService().createRequirement(
                    newRequirement,
                  );
                  ref.refresh(subsystem2RequirementListProvider);
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
    Subsystem2ReqModel req,
    bool canEdit,
    String username,
    List<Header_Sub2Req_Model> headers,
    List<Sub2AttributeModel> attributes,
  ) {
    final _descController = TextEditingController(text: req.description);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(req.title),
            content:
                canEdit
                    ? TextField(
                      controller: _descController,
                      maxLines: null,
                      decoration: const InputDecoration(labelText: 'Açıklama'),
                    )
                    : Text(req.description),
            actions: [
              if (canEdit)
                TextButton(
                  onPressed: () {
                    _showConfirmationDialog(
                      context,
                      "GÜNCELLEMEK İSTEDİĞİNİZE EMİN MİSİNİZ?",
                      () async {
                        final updatedReq = Subsystem2ReqModel(
                          id: req.id,
                          title: req.title,
                          description: _descController.text.trim(),
                          createdBy: req.createdBy,
                          flag: false,
                          systemRequirementId: req.systemRequirementId,
                          projectId: req.projectId,
                        );

                        await createChangeLogForRequirement(
                          username: username,
                          req: req,
                          headers: headers,
                          attributes: attributes,
                          changeType: 'update',
                        );

                        await Subsystem2RequirementApiService()
                            .updateRequirement(updatedReq);
                        ref.refresh(subsystem2RequirementListProvider);
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
    required Subsystem2ReqModel req,
    required List<Header_Sub2Req_Model> headers,
    required List<Sub2AttributeModel> attributes,
    required String changeType,
  }) async {
    final relatedAttributes =
        attributes.where((a) => a.subsystem2Id == req.id).toList();
    final oldHeaderTitles = headers.map((h) => h.header ?? '').toList();
    final oldAttributeDescriptions =
        relatedAttributes.map((a) => a.description ?? '').toList();

    final changeLog = Subsystem2RequirementChangeLog(
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

    await Subsystem2RequirementChangeLogApiService().create(changeLog);
  }

  static Future<void> toggleFlag(Subsystem2ReqModel req, WidgetRef ref) async {
    final updatedReq = Subsystem2ReqModel(
      id: req.id,
      title: req.title,
      description: req.description,
      createdBy: req.createdBy,
      flag: !req.flag,
      systemRequirementId: req.systemRequirementId,
      projectId: req.projectId,
    );
    await Subsystem2RequirementApiService().updateRequirement(updatedReq);
    ref.refresh(subsystem2RequirementListProvider);
  }

  static Future<void> deleteRequirement(
    String username,
    Subsystem2ReqModel req,
    WidgetRef ref,
    List<Header_Sub2Req_Model> headers,
    List<Sub2AttributeModel> attributes,
  ) async {
    await createChangeLogForRequirement(
      username: username,
      req: req,
      headers: headers,
      attributes: attributes,
      changeType: 'delete',
    );

    await Subsystem2RequirementApiService().deleteRequirement(req.id);
    ref.refresh(subsystem2RequirementListProvider);
  }

  static void showDetailPopup(
    String username,
    BuildContext context,
    WidgetRef ref,
    Subsystem2ReqModel req,
    bool isAdmin,
    bool canEdit,
    List<Header_Sub2Req_Model> headers,
    List<Sub2AttributeModel> attributes,
    List<SystemReqModel> systemRequirements,
  ) {
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

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(req.title),
            content: SizedBox(
              width: 500,
              height: 300,
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

                    Text(
                      "${linkedSystemReq.title} <<<<----",
                      style: const TextStyle(color: Colors.blueGrey),
                    ),
                    const SizedBox(height: 10),

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

                  final newHeader = Header_Sub2Req_Model(header: headerText);

                  await HeaderSub2ApiService().createRequirement(newHeader);
                  ref.refresh(headerSub2ReqModelListProvider);
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
                      final updatedAttr = Sub2AttributeModel(
                        id: attributeId,
                        title: header,
                        subsystem2Id: subSystemRequirementId,
                        description: desc,
                      );
                      await Sub2AttributeApiService().updateRequirement(
                        updatedAttr,
                      );
                    } else {
                      final newAttr = Sub2AttributeModel(
                        id: null,
                        title: header,
                        subsystem2Id: subSystemRequirementId,
                        description: desc,
                      );
                      await Sub2AttributeApiService().createRequirement(
                        newAttr,
                      );
                    }

                    // Requirement'ı flag=false yap
                    final allRequirements =
                        ref.read(subsystem2RequirementListProvider).value ?? [];
                    final target = allRequirements.firstWhere(
                      (r) => r.id == subSystemRequirementId,
                      orElse:
                          () => Subsystem2ReqModel(
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
                      final updatedReq = Subsystem2ReqModel(
                        id: target.id,
                        title: target.title,
                        description: target.description,
                        createdBy: target.createdBy,
                        systemRequirementId: target.systemRequirementId,
                        projectId: target.projectId,
                        flag: false,
                      );

                      await Subsystem2RequirementApiService().updateRequirement(
                        updatedReq,
                      );

                      final allHeaders =
                          ref.read(headerSub2ReqModelListProvider).value ?? [];
                      final allAttributes =
                          ref.read(sub2AttributeListProvider).value ?? [];

                      await controller
                          .Subsystem2RequirementsController.createChangeLogForRequirement(
                        username: username,
                        req: target,
                        headers: allHeaders,
                        attributes: allAttributes,
                        changeType: 'update-attribute',
                      );
                    }

                    ref.refresh(sub2AttributeListProvider);
                    ref.refresh(subsystem2RequirementListProvider);
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
                          ref.read(subsystem2RequirementListProvider).value ??
                          [];
                      final target = allRequirements.firstWhere(
                        (r) => r.id == subSystemRequirementId,
                        orElse:
                            () => Subsystem2ReqModel(
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
                        final updatedReq = Subsystem2ReqModel(
                          id: target.id,
                          title: target.title,
                          description: target.description,
                          createdBy: target.createdBy,
                          flag: false,
                          systemRequirementId: target.systemRequirementId,
                          projectId: target.projectId,
                        );

                        await Subsystem2RequirementApiService()
                            .updateRequirement(updatedReq);

                        final allHeaders =
                            ref.read(headerSub2ReqModelListProvider).value ??
                            [];
                        final allAttributes =
                            ref.read(sub2AttributeListProvider).value ?? [];

                        await controller
                            .Subsystem2RequirementsController.createChangeLogForRequirement(
                          username: username,
                          req: updatedReq,
                          headers: allHeaders,
                          attributes: allAttributes,
                          changeType: 'delete-attribute',
                        );
                      }

                      await Sub2AttributeApiService().deleteRequirement(
                        attributeId!,
                      );
                      ref.refresh(sub2AttributeListProvider);
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
}
