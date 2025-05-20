import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/frontend_files/loginpage/auth_service.dart';

import 'package:frontend/backend/user_requirements/user_requirement_model.dart';

import 'package:frontend/frontend_files/systemReqPage/system_requirements_controller.dart'
    as controller;

import '../../backend/attributes/system_attribute/system_attribute_api_service.dart';
import '../../backend/attributes/system_attribute/system_attribute_model.dart';
import '../../backend/attributes/system_attribute/system_attribute_provider.dart';
import '../../backend/changeLogs/system_requirements_change_log/changeLog_system_requirement_api_service.dart';
import '../../backend/changeLogs/system_requirements_change_log/changeLog_system_requirement_model.dart';
import '../../backend/headers/header_systemreq/header_systemreq_api_service.dart';
import '../../backend/headers/header_systemreq/header_systemreq_model.dart';

import '../../backend/headers/header_systemreq/header_systemreq_provider.dart';
import '../../backend/system_requirements/system_requirement_api_service.dart';
import '../../backend/system_requirements/system_requirement_model.dart';
import '../../backend/system_requirements/system_requirement_provider.dart';
import '../../backend/user_requirements/user_requirement_provider.dart';
import '../../backend/projects/selected_project_provider.dart';
import 'package:frontend/frontend_files/systemReqPage/SystemRequirementGraph.dart';
import 'package:frontend/backend/subsystems/subsystem1_requirements/subsystem1_requirement_provider.dart';
import 'package:frontend/backend/subsystems/subsystem2_requirements/subsystem2_requirement_provider.dart';
import 'package:frontend/backend/subsystems/subsystem3_requirements/subsystem3_requirement_provider.dart';

class SystemRequirementsController {
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
    final currentList = ref.read(systemRequirementListProvider).value ?? [];
    final userRequirements = ref.read(userRequirementListProvider).value ?? [];

    int maxIndex = 0;
    for (var item in currentList) {
      final match = RegExp(r'^SG-(\d+)$').firstMatch(item.title);
      if (match != null) {
        final number = int.tryParse(match.group(1)!);
        if (number != null && number > maxIndex) {
          maxIndex = number;
        }
      }
    }
    final nextTitle = 'SG-${maxIndex + 1}';

    String? selectedUserReqId;
    UserReqModel? selectedUserReq;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Yeni Sistem Gereksinimi Ekle"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Başlık: $nextTitle",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // Kullanıcı gereksinimi seçim alanı
                  DropdownButtonFormField<UserReqModel>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: "Kullanıcı Gereksinimi Seç",
                    ),
                    items:
                        userRequirements.map((req) {
                          return DropdownMenuItem<UserReqModel>(
                            value: req,
                            child: Text(req.title),
                          );
                        }).toList(),
                    onChanged: (val) {
                      selectedUserReq = val;
                      selectedUserReqId = val?.id;
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
                  if (description.isEmpty || selectedUserReqId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tüm alanlar doldurulmalı')),
                    );
                    return;
                  }

                  final newRequirement = SystemReqModel(
                    id: '',
                    title: nextTitle,
                    description: description,
                    createdBy: username,
                    flag: false,
                    user_req_id: selectedUserReqId!,
                    projectId: selectedProject.id,
                  );

                  await SystemRequirementApiService().createRequirement(
                    newRequirement,
                  );
                  ref.refresh(systemRequirementListProvider);
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
    SystemReqModel req,
    bool canEdit,
    String username,
    List<Header_SystemReq_Model> headers,
    List<SystemAttributeModel> attributes,
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
                        final updatedReq = SystemReqModel(
                          id: req.id,
                          title: req.title,
                          description: _descController.text.trim(),
                          createdBy: req.createdBy,
                          flag: false,
                          user_req_id: req.user_req_id,
                          projectId: req.projectId,
                        );

                        await createChangeLogForRequirement(
                          username: username,
                          req: req,
                          headers: headers,
                          attributes: attributes,
                          changeType: 'update',
                        );

                        await SystemRequirementApiService().updateRequirement(
                          updatedReq,
                        );
                        ref.refresh(systemRequirementListProvider);
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
    required SystemReqModel req,
    required List<Header_SystemReq_Model> headers,
    required List<SystemAttributeModel> attributes,
    required String changeType,
  }) async {
    final relatedAttributes =
        attributes.where((a) => a.systemRequirementId == req.id).toList();
    final oldHeaderTitles = headers.map((h) => h.header ?? '').toList();
    final oldAttributeDescriptions =
        relatedAttributes.map((a) => a.description ?? '').toList();

    final changeLog = SystemRequirementChangeLog(
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

    await SystemRequirementChangeLogApiService().create(changeLog);
  }

  static Future<void> toggleFlag(SystemReqModel req, WidgetRef ref) async {
    final updatedReq = SystemReqModel(
      id: req.id,
      title: req.title,
      description: req.description,
      createdBy: req.createdBy,
      flag: !req.flag,
      user_req_id: req.user_req_id,
      projectId: req.projectId,
    );
    await SystemRequirementApiService().updateRequirement(updatedReq);
    ref.refresh(systemRequirementListProvider);
  }

  static Future<void> deleteRequirement(
    String username,
    SystemReqModel req,
    WidgetRef ref,
    List<Header_SystemReq_Model> headers,
    List<SystemAttributeModel> attributes,
  ) async {
    await createChangeLogForRequirement(
      username: username,
      req: req,
      headers: headers,
      attributes: attributes,
      changeType: 'delete',
    );

    await SystemRequirementApiService().deleteRequirement(req.id);
    ref.refresh(systemRequirementListProvider);
  }

  static void showDetailPopup(
    String username,
    BuildContext context,
    WidgetRef ref,
    SystemReqModel req,
    bool isAdmin,
    bool canEdit,
    List<Header_SystemReq_Model> headers,
    List<SystemAttributeModel> attributes,
    List<UserReqModel> userRequirements,
  ) {
    final linkedUserReq = userRequirements.firstWhere(
      (u) => u.id == req.user_req_id,
      orElse:
          () => UserReqModel(
            id: '',
            title: 'Bilinmiyor',
            description: '',
            createdBy: '',
            flag: false,
            projectId: '',
          ),
    );

    /// Alt sistemleri al
    final List<String> subsystems = [
      ...ref
              .read(subsystem1RequirementListProvider)
              .value
              ?.where((s) => s.systemRequirementId == req.id)
              .map((s) => s.title)
              .cast<String>() ??
          [],
      ...ref
              .read(subsystem2RequirementListProvider)
              .value
              ?.where((s) => s.systemRequirementId == req.id)
              .map((s) => s.title)
              .cast<String>() ??
          [],
      ...ref
              .read(subsystem3RequirementListProvider)
              .value
              ?.where((s) => s.systemRequirementId == req.id)
              .map((s) => s.title)
              .cast<String>() ??
          [],
    ];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(req.title),
            content: SizedBox(
              width: 500,
              height: 400,
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

                    /// 🔗 Görsel Bağlantı Diyagramı
                    SystemRequirementGraph(
                      kgTitle: linkedUserReq.title,
                      sgTitle: req.title,
                      subsystemTitles: subsystems,
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

                  final newHeader = Header_SystemReq_Model(header: headerText);

                  await HeaderSystemApiService().createSystemHeader(newHeader);
                  ref.refresh(headerSystemReqModelListProvider);
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
    String systemRequirementId,
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

                    final newAttr = SystemAttributeModel(
                      id: attributeId,
                      header: header,
                      systemRequirementId: systemRequirementId,
                      description: desc,
                    );

                    if (attributeId != null && attributeId.isNotEmpty) {
                      final updatedAttr = SystemAttributeModel(
                        id: attributeId,
                        header: header,
                        systemRequirementId: systemRequirementId,
                        description: desc,
                      );
                      await SystemAttributeApiService().updateRequirement(
                        updatedAttr,
                      );
                    } else {
                      final newAttr = SystemAttributeModel(
                        id: null,
                        header: header,
                        systemRequirementId: systemRequirementId,
                        description: desc,
                      );
                      await SystemAttributeApiService().createRequirement(
                        newAttr,
                      );
                    }

                    // Requirement'ı flag=false yap
                    final allRequirements =
                        ref.read(systemRequirementListProvider).value ?? [];
                    final target = allRequirements.firstWhere(
                      (r) => r.id == systemRequirementId,
                      orElse:
                          () => SystemReqModel(
                            id: '',
                            title: '',
                            description: '',
                            createdBy: '',
                            flag: true,
                            user_req_id: '',
                            projectId: '',
                          ),
                    );

                    if (target.id.isNotEmpty) {
                      final updatedReq = SystemReqModel(
                        id: target.id,
                        title: target.title,
                        description: target.description,
                        createdBy: target.createdBy,
                        flag: false,
                        user_req_id: target.user_req_id,
                        projectId: target.projectId,
                      );

                      await SystemRequirementApiService().updateRequirement(
                        updatedReq,
                      );

                      final allHeaders =
                          ref.read(headerSystemReqModelListProvider).value ??
                          [];
                      final allAttributes =
                          ref.read(systemAttributeListProvider).value ?? [];

                      await controller
                          .SystemRequirementsController.createChangeLogForRequirement(
                        username: username,
                        req: target,
                        headers: allHeaders,
                        attributes: allAttributes,
                        changeType: 'update-attribute',
                      );
                    }

                    ref.refresh(systemAttributeListProvider);
                    ref.refresh(systemRequirementListProvider);
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
                          ref.read(systemRequirementListProvider).value ?? [];
                      final target = allRequirements.firstWhere(
                        (r) => r.id == systemRequirementId,
                        orElse:
                            () => SystemReqModel(
                              id: '',
                              title: '',
                              description: '',
                              createdBy: '',
                              flag: true,
                              user_req_id: '',
                              projectId: '',
                            ),
                      );

                      if (target.id.isNotEmpty) {
                        final updatedReq = SystemReqModel(
                          id: target.id,
                          title: target.title,
                          description: target.description,
                          createdBy: target.createdBy,
                          flag: false,
                          user_req_id: target.user_req_id,
                          projectId: target.projectId,
                        );

                        await SystemRequirementApiService().updateRequirement(
                          updatedReq,
                        );

                        final allHeaders =
                            ref.read(headerSystemReqModelListProvider).value ??
                            [];
                        final allAttributes =
                            ref.read(systemAttributeListProvider).value ?? [];

                        await controller
                            .SystemRequirementsController.createChangeLogForRequirement(
                          username: username,
                          req: updatedReq,
                          headers: allHeaders,
                          attributes: allAttributes,
                          changeType: 'delete-attribute',
                        );
                      }

                      await SystemAttributeApiService().deleteRequirement(
                        attributeId,
                      );
                      ref.refresh(systemAttributeListProvider);
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
}
