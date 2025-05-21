import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/frontend_files/BaselinePage/baseline_page.dart';
import 'package:frontend/frontend_files/subSystemReqPage/sub2/subsystem2_requirements_page.dart';
import 'package:frontend/frontend_files/subSystemReqPage/sub3/subsystem3_requirements_page.dart';
import 'package:frontend/frontend_files/userReqPage/user_requirements_page.dart';
import 'package:frontend/frontend_files/systemReqPage/system_requirements_page.dart';
import 'package:frontend/frontend_files/subSystemReqPage/sub1/subsystem1_requirements_page.dart';
import 'package:frontend/frontend_files/ChangeLogPage/change_log_page.dart';
import 'package:frontend/frontend_files/theme_provider.dart';
import 'package:frontend/backend/projects/selected_project_provider.dart';
import 'package:frontend/backend/projects/projects_provider.dart';
import 'package:frontend/frontend_files/homepage.dart';
import 'package:frontend/frontend_files/loginpage/auth_service.dart';

// Yeni bir provider ile seçilen modül durumunu takip ediyoruz
final selectedModuleLabelProvider = StateProvider<String?>((ref) => null);

class CustomAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  ConsumerState<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends ConsumerState<CustomAppBar> {
  late Future<Map<String, dynamic>?> _userFuture;
  late Future<List<String>> _rolesFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = AuthService.getUserInfo();
    _rolesFuture = AuthService.getUserRoles();
  }

  @override
  Widget build(BuildContext context) {
    final selectedProject = ref.watch(selectedProjectProvider);
    final allProjects = ref.watch(projectsNotifierProvider);
    final selectedModule = ref.watch(selectedModuleLabelProvider);

    return AppBar(
      backgroundColor: Colors.grey[700],
      foregroundColor: Colors.white,
      title: Row(
        children: [
          _menuButton(context),
          _headerButton("Anasayfa", () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const MyHomePage(title: "Ana Sayfa"),
              ),
              (route) => false,
            );
          }),
          _headerButton("Baseline", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SnapshotPage()),
            );
          }),
          _headerButton("Değişimler", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChangeLogPage()),
            );
          }),
          _headerButton("Dışa Aktar", () {}),

          if (allProjects.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  dropdownColor: Colors.grey[800],
                  value: selectedProject,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  items:
                      allProjects.map((project) {
                        return DropdownMenuItem(
                          value: project,
                          child: Text(
                            '📁 ${project.name}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                  onChanged: (proj) {
                    if (proj != null) {
                      ref.read(selectedProjectProvider.notifier).state = proj;
                    } else {
                      const Text("Proje Seç");
                    }
                  },
                ),
              ),
            ),

          const Spacer(),

          FutureBuilder(
            future: Future.wait([_userFuture, _rolesFuture]),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();
              final user = snapshot.data![0] as Map<String, dynamic>?;
              final roles = snapshot.data![1] as List<String>;
              return Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.brightness_6, color: Colors.white),
                    onPressed: () {
                      final current = ref.read(themeModeProvider);
                      ref.read(themeModeProvider.notifier).state =
                          current == ThemeMode.dark
                              ? ThemeMode.light
                              : ThemeMode.dark;
                    },
                  ),
                  if (user != null)
                    Text(
                      "👤 ${user['username']}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  const SizedBox(width: 10),
                  if (roles.isNotEmpty)
                    Text(
                      "🎯 ${roles.join(', ') == 'system_engineer' ? 'system engineer' : roles.join(', ')}",
                      style: const TextStyle(color: Colors.white),
                    ),
                ],
              );
            },
          ),

          const SizedBox(width: 10),
          Text(
            'CSEK',
            style: const TextStyle(
              fontFamily: 'MysteryQuest',
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              AuthService.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[300],
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
            ),
            child: const Text("Çıkış Yap"),
          ),
        ],
      ),
    );
  }

  Widget _menuButton(BuildContext context) {
    final label = ref.watch(selectedModuleLabelProvider) ?? "Modül Seç";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: PopupMenuButton<String>(
        onSelected: (value) {
          late Widget page;
          late String label;
          switch (value) {
            case 'user':
              page = const UserRequirementsPage(
                title: 'Kullanıcı Gereksinimleri',
              );
              label = "Kullanıcı Gereksinimleri";
              break;
            case 'system':
              page = const SystemRequirementsPage(
                title: 'Sistem Gereksinimleri',
              );
              label = "Sistem Gereksinimleri";
              break;
            case 'donanım':
              page = const Subsystem1RequirementsPage(
                title: 'Donanım Gereksinimleri',
              );
              label = "Donanım Gereksinimleri";
              break;
            case 'yazılım':
              page = const Subsystem2RequirementsPage(
                title: 'Yazılım Gereksinimleri',
              );
              label = "Yazılım Gereksinimleri";
              break;
            case 'güvenlik':
              page = const Subsystem3RequirementsPage(
                title: 'Güvenlik Gereksinimleri',
              );
              label = "Güvenlik Gereksinimleri";
              break;
            default:
              return;
          }
          ref.read(selectedModuleLabelProvider.notifier).state = label;
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
        itemBuilder:
            (context) => const [
              PopupMenuItem(
                value: 'user',
                child: Text("Kullanıcı Gereksinimleri"),
              ),
              PopupMenuItem(
                value: 'system',
                child: Text("Sistem Gereksinimleri"),
              ),
              PopupMenuItem(
                value: 'donanım',
                child: Text("Donanım Gereksinimleri"),
              ),
              PopupMenuItem(
                value: 'yazılım',
                child: Text("Yazılım Gereksinimleri"),
              ),
              PopupMenuItem(
                value: 'güvenlik',
                child: Text("Güvenlik Gereksinimleri"),
              ),
            ],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _headerButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
