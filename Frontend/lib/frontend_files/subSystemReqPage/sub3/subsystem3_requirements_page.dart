import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/frontend_files/custom_app_bar.dart';
import 'package:frontend/frontend_files/subSystemReqPage/sub3/subsystem3_requirements_controller.dart'
    as controller;
import 'package:frontend/frontend_files/ui_constants.dart';

import '../../../backend/attributes/sub3_attribute/sub3_attribute_model.dart';
import '../../../backend/attributes/sub3_attribute/sub3_attribute_provider.dart';
import '../../../backend/headers/header_sub3req/header_sub3req_provider.dart';
import '../../../backend/subsystems/subsystem3_requirements/subsystem3_requirement_provider.dart';
import '../../../backend/system_requirements/system_requirement_provider.dart';

class Subsystem3RequirementsPage extends ConsumerStatefulWidget {
  const Subsystem3RequirementsPage({super.key, required this.title});
  final String title;

  @override
  ConsumerState<Subsystem3RequirementsPage> createState() =>
      _Subsystem1RequirementsPage();
}

class _Subsystem1RequirementsPage
    extends ConsumerState<Subsystem3RequirementsPage> {
  String? username;
  List<String> roles = [];

  @override
  void initState() {
    super.initState();
    controller.Subsystem3RequirementsController.loadUserInfo((u, r) {
      setState(() {
        username = u;
        roles = r;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final subsystem1Requirements = ref.watch(subsystem3RequirementListProvider);
    final attributes = ref.watch(sub3AttributeListProvider);
    final headers = ref.watch(headerSub3ReqModelListProvider);

    final isAdmin = roles.contains("admin");
    final isSystemEngineer = roles.contains("system_engineer");
    final canEdit = isAdmin || isSystemEngineer;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: subsystem1Requirements.when(
        data: (items) {
          final headerList = headers.value ?? [];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if (canEdit)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text("Kolon Ekle"),
                        onPressed: () {
                          controller
                              .Subsystem3RequirementsController.showAddHeaderDialog(
                            context,
                            ref,
                            username!,
                          );
                        },
                      ),
                      const SizedBox(width: 12), // Butonlar arası boşluk
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text("Yeni Gereksinim"),
                        onPressed: () {
                          controller
                              .Subsystem3RequirementsController.showAddRequirementDialog(
                            context,
                            ref,
                            username!,
                          );
                        },
                      ),
                    ],
                  ),
                const SizedBox(height: 8),

                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 150),
                            const SizedBox(width: 200),
                            ...headerList.map(
                              (h) => SizedBox(
                                width: 120,
                                child: Text(
                                  h.header,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 40),
                          ],
                        ),
                        const SizedBox(height: 8),

                        /// Data Rows
                        ...items.map((req) {
                          return GestureDetector(
                            onTap: () {
                              final attributeList = attributes.value ?? [];

                              controller
                                  .Subsystem3RequirementsController.showDetailPopup(
                                username!,
                                context,
                                ref,
                                req,
                                isAdmin,
                                canEdit,
                                headerList,
                                attributeList,
                                ref.read(systemRequirementListProvider).value ??
                                    [],
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              ),
                              child: Row(
                                children: [
                                  /// DG Kodu
                                  Container(
                                    width: isimUzunluk,
                                    color: Colors.grey[400],
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 8,
                                    ),
                                    child: Tooltip(
                                      message: req.createdBy,
                                      child: Text(
                                        req.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),

                                  /// Açıklama
                                  Container(
                                    width: widthUzunluk,
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      req.description.length > uzunluk
                                          ? '${req.description.substring(0, uzunluk)}...'
                                          : req.description,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  /// Dynamic Header Cells
                                  ...headerList.map((h) {
                                    final matchingAttr = attributes.value
                                        ?.firstWhere(
                                          (attr) =>
                                              attr.subsystem3Id == req.id &&
                                              attr.title == h.header,
                                          orElse:
                                              () => Sub3AttributeModel(
                                                title: '',
                                                subsystem3Id: '',
                                                description: '',
                                              ),
                                        );

                                    final desc = matchingAttr?.description;
                                    final isEmpty =
                                        desc == null || desc.isEmpty;

                                    return Container(
                                      width: 120,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Tooltip(
                                        message: isEmpty ? "Ekle" : desc!,
                                        child: GestureDetector(
                                          onTap: () {
                                            controller
                                                .Subsystem3RequirementsController.showAttributeDialog(
                                              context,
                                              ref,
                                              req.id,
                                              h.header,
                                              username!,
                                              isEmpty ? null : desc,
                                              attributeId:
                                                  isEmpty
                                                      ? null
                                                      : matchingAttr?.id,
                                              canEdit: canEdit,
                                            );
                                          },
                                          child:
                                              isEmpty
                                                  ? const Icon(
                                                    Icons.add,
                                                    size: 18,
                                                    color: Colors.blueGrey,
                                                  )
                                                  : Text(
                                                    desc.length > 15
                                                        ? '${desc.substring(0, 15)}...'
                                                        : desc,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                        ),
                                      ),
                                    );
                                  }),

                                  /// Flag
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child:
                                        isAdmin
                                            ? IconButton(
                                              icon: Icon(
                                                req.flag
                                                    ? Icons.check_circle
                                                    : Icons.help_outline,
                                                color:
                                                    req.flag
                                                        ? Colors.green
                                                        : Colors.orange,
                                              ),
                                              onPressed:
                                                  () => controller
                                                      .Subsystem3RequirementsController.toggleFlag(
                                                    req,
                                                    ref,
                                                  ),
                                            )
                                            : Icon(
                                              req.flag
                                                  ? Icons.check_circle
                                                  : Icons.help_outline,
                                              color:
                                                  req.flag
                                                      ? Colors.green
                                                      : Colors.orange,
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
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
      ),
    );
  }
}
