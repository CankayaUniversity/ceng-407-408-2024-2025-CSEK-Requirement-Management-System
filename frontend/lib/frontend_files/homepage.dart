import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/backend/attributes/sub1_attribute/sub1_attribute_provider.dart';
import 'package:frontend/backend/attributes/sub2_attribute/sub2_attribute_provider.dart';
import 'package:frontend/backend/attributes/sub3_attribute/sub3_attribute_provider.dart';
import 'package:frontend/backend/attributes/system_attribute/system_attribute_provider.dart';
import 'package:frontend/backend/attributes/user_attribute/user_attribute_provider.dart';
import 'package:frontend/backend/changeLogs/subsystem1_requirements_change_log/changeLog_subsystem1_requirement_provider.dart';
import 'package:frontend/backend/changeLogs/subsystem2_requirements_change_log/changeLog_subsystem2_requirement_provider.dart';
import 'package:frontend/backend/changeLogs/subsystem3_requirements_change_log/changeLog_subsystem3_requirement_provider.dart';
import 'package:frontend/backend/changeLogs/system_requirements_change_log/changeLog_system_requirement_provider.dart';
import 'package:frontend/backend/changeLogs/user_requirements_change_log/changeLog_user_requirement_provider.dart';
import 'package:frontend/backend/headers/header_sub1req/header_sub1req_provider.dart';
import 'package:frontend/backend/headers/header_sub2req/header_sub2req_provider.dart';
import 'package:frontend/backend/headers/header_sub3req/header_sub3req_provider.dart';
import 'package:frontend/backend/headers/header_systemreq/header_systemreq_provider.dart';
import 'package:frontend/backend/headers/header_userreq/header_userreq_provider.dart';
import 'package:frontend/backend/subsystems/subsystem1_requirements/subsystem1_requirement_provider.dart';
import 'package:frontend/backend/subsystems/subsystem2_requirements/subsystem2_requirement_provider.dart';
import 'package:frontend/backend/subsystems/subsystem3_requirements/subsystem3_requirement_provider.dart';
import 'package:frontend/backend/system_requirements/system_requirement_provider.dart';
import 'package:frontend/backend/user_requirements/user_requirement_provider.dart';
import 'package:frontend/frontend_files/custom_app_bar.dart';
import 'package:frontend/frontend_files/loginpage/auth_service.dart';
import 'package:frontend/backend/projects/projects_model.dart';
import 'package:frontend/backend/projects/selected_project_provider.dart';
import 'package:frontend/backend/projects/projects_provider.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  Map<String, dynamic>? user;
  List<String> roles = [];
  final TextEditingController _projectNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadUserRoles();
  }

  void _loadAllModuleData() {
    // USER
    ref.read(userRequirementListProvider);
    ref.read(headerUserReqModelListProvider);
    ref.read(userAttributeListProvider);
    ref.read(userRequirementChangeLogApiProvider);

    // SYSTEM
    ref.read(systemRequirementListProvider);
    ref.read(headerSystemReqModelListProvider);
    ref.read(systemAttributeListProvider);
    ref.read(systemRequirementChangeLogApiProvider);

    // SUBSYSTEM 1
    ref.read(subsystem1RequirementListProvider);
    ref.read(sub1HeaderListProvider);
    ref.read(sub1AttributeListProvider);
    ref.read(subsystem1RequirementChangeLogApiProvider);

    // SUBSYSTEM 2
    ref.read(subsystem2RequirementListProvider);
    ref.read(headerSub2ReqModelListProvider);
    ref.read(sub2AttributeListProvider);
    ref.read(subsystem2RequirementChangeLogApiProvider);

    // SUBSYSTEM 3
    ref.read(subsystem3RequirementListProvider);
    ref.read(headerSub3ReqModelListProvider);
    ref.read(sub3AttributeListProvider);
    ref.read(subsystem3RequirementChangeLogApiProvider);
  }

  Future<void> _loadUserInfo() async {
    final info = await AuthService.getUserInfo();
    setState(() {
      user = info;
    });
  }

  Future<void> _loadUserRoles() async {
    final _roles = await AuthService.getUserRoles();
    setState(() {
      roles = _roles;
    });
  }

  void _showCreateProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: const Text(
              "Yeni Proje Oluştur",
              style: TextStyle(color: Colors.white),
            ),
            content: TextField(
              controller: _projectNameController,
              decoration: const InputDecoration(
                hintText: "Proje adı",
                hintStyle: TextStyle(color: Colors.white54),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("İptal"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final name = _projectNameController.text.trim();
                  if (name.isNotEmpty) {
                    final newProject = ProjectsModel(id: '', name: name);
                    await ref
                        .read(projectsNotifierProvider.notifier)
                        .addProject(newProject);
                    _projectNameController.clear();
                    Navigator.pop(context);
                  }
                },
                child: const Text("Oluştur"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final username = user?['username'] ?? 'Bilinmiyor';
    final fullName = user?['name'] ?? 'İsim Yok';
    final email = user?['email'] ?? 'E-posta Yok';
    final selectedProject = ref.watch(selectedProjectProvider);
    final allProjects = ref.watch(projectsNotifierProvider);

    if (selectedProject != null) {
      Future.microtask(() => _loadAllModuleData());
    }
    ref.listen<ProjectsModel?>(selectedProjectProvider, (prev, next) {
      if (next != null) {
        _loadAllModuleData();
      }
    });

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LOGO + BAŞLIK KUTUSU
              SizedBox(
                width: 420,
                child: Card(
                  color: Colors.grey[900],
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 32.0,
                    ),
                    child: Column(
                      children: [
                        // 🌟 Logo
                        Container(
                          width: 140,
                          height: 140,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/projectlogo.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        const Text(
                          "CSEK Gereksinim Sistemi",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButton<ProjectsModel>(
                                dropdownColor: Colors.grey[800],
                                hint: const Text(
                                  "Proje Seç",
                                  style: TextStyle(color: Colors.white),
                                ),
                                value: selectedProject,
                                onChanged:
                                    (proj) =>
                                        ref
                                            .read(
                                              selectedProjectProvider.notifier,
                                            )
                                            .state = proj,
                                items:
                                    allProjects
                                        .map(
                                          (p) => DropdownMenuItem(
                                            value: p,
                                            child: Text(
                                              p.name,
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.add),
                              onPressed:
                                  () => _showCreateProjectDialog(context),
                              label: const Text("Yeni Proje"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // KULLANICI BİLGİLERİ KUTUSU
              SizedBox(
                width: 420,
                child: Card(
                  color: Colors.grey[900],
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 32.0,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Kullanıcı Bilgileri',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow('👤 Kullanıcı Adı:', username),
                        _buildInfoRow('📛 İsim Soyisim:', fullName),
                        _buildInfoRow('📧 E-posta:', email),
                        _buildInfoRow(
                          '🎯 Rol:',
                          roles.isNotEmpty ? roles.join(', ') : 'Rol Yok',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(value, style: const TextStyle(color: Colors.white60)),
          ),
        ],
      ),
    );
  }
}
