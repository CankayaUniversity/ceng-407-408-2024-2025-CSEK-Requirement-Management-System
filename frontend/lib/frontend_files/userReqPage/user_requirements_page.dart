import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/backend/attributes/user_attribute/user_attribute_provider.dart';
import 'package:frontend/backend/headers/header_userreq/header_userreq_provider.dart';
import 'package:frontend/backend/user_requirements/user_requirement_model.dart';
import 'package:frontend/backend/user_requirements/user_requirement_provider.dart';
import 'package:frontend/frontend_files/custom_app_bar.dart';
import 'package:frontend/frontend_files/userReqPage/user_requirements_controller.dart' as controller;

import '../../backend/attributes/user_attribute/user_attribute_model.dart';

class UserRequirementsPage extends ConsumerStatefulWidget {
  const UserRequirementsPage({super.key, required this.title});
  final String title;

  @override
  ConsumerState<UserRequirementsPage> createState() => _UserRequirementsPageState();
}

class _UserRequirementsPageState extends ConsumerState<UserRequirementsPage> {
  String? username;
  List<String> roles = [];


  @override
  void initState() {
    super.initState();
    controller.UserRequirementsController.loadUserInfo((u, r) {
      setState(() {
        username = u;
        roles = r;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userRequirements = ref.watch(userRequirementListProvider);
    final attributes = ref.watch(userAttributeListProvider);
    final headers = ref.watch(headerUserReqModelListProvider);

    int uzunluk = 10;

    final isAdmin = roles.contains("admin");
    final isSystemEngineer = roles.contains("system_engineer");
    final canEdit = isAdmin || isSystemEngineer;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: userRequirements.when(
          data: (items) {
            final headerList = headers.value ?? [];

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Header Ekle butonu
                  if (canEdit)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text("Header Ekle"),
                          onPressed: () {
                            controller.UserRequirementsController.showAddHeaderDialog(
                              context,
                              ref,
                              username!,
                            );
                          },
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),


                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [

                        Row(
                          children: [
                            const SizedBox(width: 150),
                            const SizedBox(width: 200),
                            ...headerList.map((h) => SizedBox(
                              width: 120,
                              child: Text(
                                h.header,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )),
                            const SizedBox(width: 40),
                          ],
                        ),
                        const SizedBox(height: 8),

                        ...items.map((req) {
                          return GestureDetector(
                            onTap: () {
                              final attributeList = attributes.value ?? [];

                              controller.UserRequirementsController.showDetailPopup(
                                username!,
                                context,
                                ref,
                                req,
                                isAdmin,
                                canEdit,
                                headerList,
                                attributeList,
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                              child: Row(
                                children: [
                                  // KG kodu
                                  Container(
                                    width: 150,
                                    color: Colors.grey[400],
                                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                                    child: Tooltip(
                                      message: req.createdBy,
                                      child: Text(
                                        req.title,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    width: 200,
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      req.description.length > uzunluk
                                          ? '${req.description.substring(0, uzunluk)}...'
                                          : req.description,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  ...headerList.map((h) {
                                    final matchingAttr = attributes.value?.firstWhere(
                                          (attr) => attr.userRequirementId == req.id && attr.header == h.header,
                                      orElse: () => UserAttributeModel(header: '', userRequirementId: '', description: ''),
                                    );

                                    final desc = matchingAttr?.description;
                                    final isEmpty = desc == null || desc.isEmpty;

                                    return Container(
                                      width: 120,
                                      padding: const EdgeInsets.all(8.0),
                                      child: isEmpty
                                          ? IconButton(
                                        icon: const Icon(Icons.add, size: 18),
                                        onPressed: () {
                                          controller.UserRequirementsController.showAddAttributeDialog(
                                            context,
                                            ref,
                                            req.id,
                                            h.header,
                                          );
                                        },
                                      )
                                          : Tooltip(
                                        message: desc!,
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (_) => AlertDialog(
                                                title: Text("${req.title} - ${h.header}"),
                                                content: SingleChildScrollView(child: Text(desc)),
                                                actions: [
                                                  TextButton(
                                                    child: const Text("Kapat"),
                                                    onPressed: () => Navigator.of(context).pop(),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Text(
                                            desc.length > 15 ? '${desc.substring(0, 15)}...' : desc,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),



                                  // Flag icon
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: isAdmin
                                        ? IconButton(
                                      icon: Icon(
                                        req.flag ? Icons.check_circle : Icons.help_outline,
                                        color: req.flag ? Colors.green : Colors.orange,
                                      ),
                                      onPressed: () => controller.UserRequirementsController.toggleFlag(req, ref),
                                    )
                                        : Icon(
                                      req.flag ? Icons.check_circle : Icons.help_outline,
                                      color: req.flag ? Colors.green : Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
      ),
      floatingActionButton: canEdit
          ? FloatingActionButton(
        onPressed: () => controller.UserRequirementsController.showAddRequirementDialog(
          context,
          ref,
          username!,
        ),
        child: const Icon(Icons.add),
      )
          : null,
    );
  }
}