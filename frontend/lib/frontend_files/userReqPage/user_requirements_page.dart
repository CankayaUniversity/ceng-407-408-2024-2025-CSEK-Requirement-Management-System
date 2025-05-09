import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/backend/attributes/user_attribute/user_attribute_provider.dart';
import 'package:frontend/backend/headers/header_userreq/header_userreq_provider.dart';
import 'package:frontend/backend/user_requirements/user_requirement_model.dart';
import 'package:frontend/backend/user_requirements/user_requirement_provider.dart';
import 'package:frontend/frontend_files/custom_app_bar.dart';
import 'package:frontend/frontend_files/userReqPage/user_requirements_controller.dart' as controller;

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
        data: (items) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final req = items[index];
                    return GestureDetector(
                      onTap: () {
                        final headerList = headers.value ?? [];
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
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  req.description.length > uzunluk
                                      ? '${req.description.substring(0, uzunluk)}...'
                                      : req.description,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
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
                  },
                ),
              ),
            ],
          ),
        ),
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