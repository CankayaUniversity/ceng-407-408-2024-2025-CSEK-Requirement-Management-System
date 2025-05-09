import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/backend/system_requirements/system_requirement_provider.dart' as system;
import 'package:frontend/backend/system_requirements/system_requirement_model.dart';
import 'package:frontend/backend/system_requirements/system_requirement_api_service.dart';
import 'package:frontend/backend/user_requirements/user_requirement_model.dart';
import 'package:frontend/backend/user_requirements/user_requirement_provider.dart' as user;

class SystemRequirementsPage extends ConsumerStatefulWidget {
  const SystemRequirementsPage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<SystemRequirementsPage> createState() => _SystemRequirementsPageState();
}

class _SystemRequirementsPageState extends ConsumerState<SystemRequirementsPage> {
  void _showAddRequirementDialog(List<UserReqModel> userRequirements) {
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _flagController = TextEditingController();
    String? selectedLinkId;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Yeni Sistem Gereksinimi Ekle"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Başlık')),
              TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Açıklama')),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Bağlı User Req'),
                value: selectedLinkId,
                items: userRequirements.map((req) {
                  return DropdownMenuItem<String>(
                    value: req.id,
                    child: Text(req.title),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedLinkId = value;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (selectedLinkId == null) return;

              final newRequirement = SystemReqModel(
                id: '',
                title: _titleController.text,
                description: _descriptionController.text,
                createdBy: 'placeholderUser',
                user_req_id: selectedLinkId!,
                flag: false,
              );

              final apiService = SystemRequirementApiService();
              await apiService.createRequirement(newRequirement);
              ref.refresh(system.systemRequirementListProvider);
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

  @override
  Widget build(BuildContext context) {
    final systemRequirements = ref.watch(system.systemRequirementListProvider);
    final userRequirements = ref.watch(user.userRequirementListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: systemRequirements.when(
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final requirement = items[index];
            return ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Başlık: ${requirement.title}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('ID: ${requirement.id}'),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Açıklama: ${requirement.description}'),
                  Text('Oluşturan: ${requirement.createdBy}'),
                  Text('Link ID: ${requirement.user_req_id}'),
                  Text('Bayrak: ${requirement.flag}'),
                ],
              ),
              isThreeLine: true,
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
      ),
      floatingActionButton: userRequirements.when(
        data: (userReqs) => FloatingActionButton(
          onPressed: () => _showAddRequirementDialog(userReqs),
          child: const Icon(Icons.add),
        ),
        loading: () => const SizedBox.shrink(),
        error: (e, _) => const SizedBox.shrink(),
      ),
    );
  }
}