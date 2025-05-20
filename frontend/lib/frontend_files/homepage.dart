import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
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
                        const Text(
                          "CSEK Requirement Management System",
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
