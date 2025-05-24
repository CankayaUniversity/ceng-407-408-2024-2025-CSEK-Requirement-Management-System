import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/backend/headers/header_userreq/header_userreq_provider.dart';
import 'package:frontend/backend/user_requirements/user_requirement_model.dart';
import 'package:frontend/backend/user_requirements/user_requirement_provider.dart';
import 'package:frontend/backend/user_requirements/user_requirement_api_service.dart';
import 'package:frontend/frontend_files/loginpage/auth_service.dart';
import 'package:frontend/frontend_files/userReqPage/user_requirements_controller.dart'
    as controller;

import '../../backend/attributes/user_attribute/user_attribute_api_service.dart';
import '../../backend/attributes/user_attribute/user_attribute_model.dart';
import '../../backend/attributes/user_attribute/user_attribute_provider.dart';
import '../../backend/changeLogs/user_requirements_change_log/changeLog_user_requirement_api_service.dart';
import '../../backend/changeLogs/user_requirements_change_log/changeLog_user_requirement_model.dart';
import '../../backend/headers/header_userreq/header_userreq_api_service.dart';
import '../../backend/headers/header_userreq/header_userreq_model.dart';
import '../../backend/projects/selected_project_provider.dart';

import 'package:frontend/frontend_files/userReqPage/UserRequirementGraph.dart';
import '../../../backend/system_requirements/system_requirement_provider.dart';
import '../../../backend/system_requirements/system_requirement_model.dart';
import 'package:frontend/backend/subsystems/subsystem1_requirements/subsystem1_requirement_provider.dart';
import 'package:frontend/backend/subsystems/subsystem2_requirements/subsystem2_requirement_provider.dart';
import 'package:frontend/backend/subsystems/subsystem3_requirements/subsystem3_requirement_provider.dart';

class UserRequirementsController {
  /// Kullanıcı adını ve rollerini getirir
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
    final currentList = ref.read(userRequirementListProvider).value ?? [];

    int maxIndex = 0;
    for (var item in currentList) {
      final match = RegExp(r'^KG-(\d+)$').firstMatch(item.title);
      if (match != null) {
        final number = int.tryParse(match.group(1)!);
        if (number != null && number > maxIndex) {
          maxIndex = number;
        }
      }
    }
    final nextTitle = 'KG-${maxIndex + 1}';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Yeni Gereksinim Ekle"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Başlık: $nextTitle",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                  if (description.isEmpty) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Açıklama boş olamaz')),
                    );
                    return;
                  }

                  final newRequirement = UserReqModel(
                    id: '',
                    title: nextTitle,
                    description: description,
                    createdBy: username,
                    flag: false,
                    projectId: selectedProject.id,
                  );

                  await UserRequirementApiService().createRequirement(
                    newRequirement,
                  );
                  ref.refresh(userRequirementListProvider);
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

  static void showDescriptionDialog(
    BuildContext context,
    WidgetRef ref,
    UserReqModel req,
    bool canEdit,
    String username,
    List<Header_UserReq_Model> headers,
    List<UserAttributeModel> attributes,
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
                        // Yeni requirement nesnesi
                        final updatedReq = UserReqModel(
                          id: req.id,
                          title: req.title,
                          description: _descController.text.trim(),
                          createdBy: req.createdBy,
                          flag: false,
                          projectId: req.projectId,
                        );

                        // ChangeLog kaydı oluştur
                        await controller
                            .UserRequirementsController.createChangeLogForRequirement(
                          username: username!,
                          req: req,
                          headers: headers,
                          attributes: attributes,
                          changeType: 'update',
                        );

                        // Güncelleme işlemini yap
                        await UserRequirementApiService().updateRequirement(
                          updatedReq,
                        );

                        // Listeyi yenile
                        ref.refresh(userRequirementListProvider);

                        // Popup'ı kapat
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
    required UserReqModel req,
    required List<Header_UserReq_Model> headers,
    required List<UserAttributeModel> attributes,
    required String changeType,
  }) async {
    final relatedAttributes =
        attributes.where((a) => a.userRequirementId == req.id).toList();

    final usedHeaders =
        headers.where((header) {
          return relatedAttributes.any((attr) => attr.header == header.header);
        }).toList();

    final oldHeaderTitles = usedHeaders.map((h) => h.header ?? '').toList();

    final oldAttributeDescriptions =
        relatedAttributes.map((a) => a.description ?? '').toList();

    final changeLog = UserRequirementChangeLog(
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

    await UserRequirementChangeLogApiService().create(changeLog);
  }

  static Future<void> toggleFlag(UserReqModel req, WidgetRef ref) async {
    final updatedReq = UserReqModel(
      id: req.id,
      title: req.title,
      description: req.description,
      createdBy: req.createdBy,
      flag: !req.flag,
      projectId: req.projectId,
    );
    await UserRequirementApiService().updateRequirement(updatedReq);
    ref.refresh(userRequirementListProvider);
  }

  static Future<void> deleteRequirement(
    String username,
    UserReqModel req,
    WidgetRef ref,
    List<Header_UserReq_Model> headers,
    List<UserAttributeModel> attributes,
  ) async {
    await createChangeLogForRequirement(
      username: username,
      req: req,
      headers: headers,
      attributes: attributes,
      changeType: 'delete',
    );

    await UserRequirementApiService().deleteRequirement(req.id);

    ref.refresh(userRequirementListProvider);
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

  static void showAttributeDialog(
    BuildContext context,
    WidgetRef ref,
    String userRequirementId,
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

                    final newAttr = UserAttributeModel(
                      id: attributeId,
                      header: header,
                      userRequirementId: userRequirementId,
                      description: desc,
                    );

                    if (attributeId != null && attributeId.isNotEmpty) {
                      final updatedAttr = UserAttributeModel(
                        id: attributeId,
                        header: header,
                        userRequirementId: userRequirementId,
                        description: desc,
                      );
                      await UserAttributeApiService().updateRequirement(
                        updatedAttr,
                      );
                    } else {
                      final newAttr = UserAttributeModel(
                        id: null,
                        header: header,
                        userRequirementId: userRequirementId,
                        description: desc,
                      );
                      await UserAttributeApiService().createRequirement(
                        newAttr,
                      );
                    }

                    // Requirement'ı flag=false yap
                    final allRequirements =
                        ref.read(userRequirementListProvider).value ?? [];
                    final target = allRequirements.firstWhere(
                      (r) => r.id == userRequirementId,
                      orElse:
                          () => UserReqModel(
                            id: '',
                            title: '',
                            description: '',
                            createdBy: '',
                            flag: true,
                            projectId: '',
                          ),
                    );

                    if (target.id.isNotEmpty && target.projectId.isNotEmpty) {
                      final updatedReq = UserReqModel(
                        id: target.id,
                        title: target.title,
                        description: target.description,
                        createdBy: target.createdBy,
                        flag: false,
                        projectId: target.projectId,
                      );

                      await UserRequirementApiService().updateRequirement(
                        updatedReq,
                      );

                      final allHeaders =
                          ref.read(headerUserReqModelListProvider).value ?? [];
                      final allAttributes =
                          ref.read(userAttributeListProvider).value ?? [];

                      await controller
                          .UserRequirementsController.createChangeLogForRequirement(
                        username: username,
                        req: target,
                        headers: allHeaders,
                        attributes: allAttributes,
                        changeType: 'update-attribute',
                      );
                    }

                    ref.refresh(userAttributeListProvider);
                    ref.refresh(userRequirementListProvider);
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
                          ref.read(userRequirementListProvider).value ?? [];
                      final target = allRequirements.firstWhere(
                        (r) => r.id == userRequirementId,
                        orElse:
                            () => UserReqModel(
                              id: '',
                              title: '',
                              description: '',
                              createdBy: '',
                              flag: true,
                              projectId: '',
                            ),
                      );

                      if (target.id.isNotEmpty) {
                        final updatedReq = UserReqModel(
                          id: target.id,
                          title: target.title,
                          description: target.description,
                          createdBy: target.createdBy,
                          flag: false,
                          projectId: target.projectId,
                        );

                        await UserRequirementApiService().updateRequirement(
                          updatedReq,
                        );

                        final allHeaders =
                            ref.read(headerUserReqModelListProvider).value ??
                            [];
                        final allAttributes =
                            ref.read(userAttributeListProvider).value ?? [];

                        await controller
                            .UserRequirementsController.createChangeLogForRequirement(
                          username: username,
                          req: updatedReq,
                          headers: allHeaders,
                          attributes: allAttributes,
                          changeType: 'delete-attribute',
                        );
                      }

                      await UserAttributeApiService().deleteRequirement(
                        attributeId,
                      );
                      ref.refresh(userAttributeListProvider);
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

                  final newHeader = Header_UserReq_Model(header: headerText);

                  await HeaderApiService().createRequirement(newHeader);
                  ref.refresh(headerUserReqModelListProvider);
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

  static void showDetailPopup(
    String username,
    BuildContext context,
    WidgetRef ref,
    UserReqModel req,
    bool isAdmin,
    bool canEdit,
    List<Header_UserReq_Model> headers,
    List<UserAttributeModel> attributes,
  ) {
    /// 1. Bu user requirement’a bağlı system requirementları al
    final systemRequirements =
        ref.read(systemRequirementListProvider).value ?? [];
    final linkedSystem = systemRequirements.firstWhere(
      (s) => s.user_req_id == req.id,
      orElse:
          () => SystemReqModel(
            id: '',
            title: 'Bağlı SG yok',
            description: '',
            createdBy: '',
            flag: false,
            user_req_id: '',
            projectId: '',
          ),
    );
    final systemRequirementList =
        ref.read(systemRequirementListProvider).value ?? [];
    final subsystem1List =
        ref.read(subsystem1RequirementListProvider).value ?? [];
    final subsystem2List =
        ref.read(subsystem2RequirementListProvider).value ?? [];
    final subsystem3List =
        ref.read(subsystem3RequirementListProvider).value ?? [];

    /// 2. Bu SG’ye bağlı subsystem’leri al
    final subs1 =
        ref
            .read(subsystem1RequirementListProvider)
            .value
            ?.where((s) => s.systemRequirementId == linkedSystem.id)
            .map((s) => s.title)
            .toList();

    final subs2 =
        ref
            .read(subsystem2RequirementListProvider)
            .value
            ?.where((s) => s.systemRequirementId == linkedSystem.id)
            .map((s) => s.title)
            .toList();

    final subs3 =
        ref
            .read(subsystem3RequirementListProvider)
            .value
            ?.where((s) => s.systemRequirementId == linkedSystem.id)
            .map((s) => s.title)
            .toList();

    final allSubsystems = [...?subs1, ...?subs2, ...?subs3];

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

                    /// 🧠 Grafik
                    UserRequirementGraph(
                      kgTitle: req.title,
                      systemRequirements:
                          systemRequirementList
                              .where((sg) => sg.user_req_id == req.id)
                              .toList(),
                      subsystem1: subsystem1List,
                      subsystem2: subsystem2List,
                      subsystem3: subsystem3List,
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

  static Future<String?> CALISMIYORshowAddHeaderDialog(
    BuildContext context,
    WidgetRef ref,
    String username,
  ) async {
    final _headerController = TextEditingController();

    return showDialog<String>(
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
                onPressed: () => Navigator.of(context).pop(), // sadece kapat
                child: const Text("İptal"),
              ),
              TextButton(
                onPressed: () async {
                  final headerText = _headerController.text.trim();
                  if (headerText.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Header adı boş olamaz")),
                    );
                    return;
                  }

                  final newHeader = Header_UserReq_Model(header: headerText);
                  await HeaderApiService().createRequirement(newHeader);
                  ref.refresh(headerUserReqModelListProvider);

                  Navigator.of(
                    context,
                  ).pop(headerText); // eklenen header'ı döndür
                },
                child: const Text("Ekle"),
              ),
            ],
          ),
    );
  }
}
