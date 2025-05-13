import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/frontend_files/subSystemReqPage/sub2/subsystem2_requirements_page.dart';
import 'package:frontend/frontend_files/subSystemReqPage/sub3/subsystem3_requirements_page.dart';
import 'loginpage/auth_service.dart';
import 'package:frontend/frontend_files/userReqPage/user_requirements_page.dart';
import 'package:frontend/frontend_files/systemReqPage/system_requirements_page.dart';
import 'package:frontend/frontend_files/subSystemReqPage/sub1/subsystem1_requirements_page.dart';
import 'package:frontend/frontend_files/ChangeLogPage/change_log_page.dart';
import 'package:frontend/frontend_files/theme_provider.dart';

class CustomAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  ConsumerState<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends ConsumerState<CustomAppBar> {
  String? username;
  List<String> roles = [];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final info = await AuthService.getUserInfo();
    final userRoles = await AuthService.getUserRoles();
    setState(() {
      username = info?['username'] ?? 'Bilinmiyor';
      roles = userRoles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[700],
      title: Row(
        children: [
          _menuButton(context),
          _headerButton("Baseline", () {}),
          _headerButton("Değişimler", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChangeLogPage()),
            );
          }),
          _headerButton("Dışa Aktar", () {}),
          const Spacer(),

          IconButton(
            icon: const Icon(Icons.brightness_6, color: Colors.white),
            onPressed: () {
              final current = ref.read(themeModeProvider);
              ref.read(themeModeProvider.notifier).state =
                  current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
          if (username != null)
            Text("👤 $username", style: const TextStyle(color: Colors.white)),
          const SizedBox(width: 10),
          if (roles.isNotEmpty)
            Text(
              "🎯 ${roles.join(', ') == 'system_engineer' ? 'system engineer' : roles.join(', ')}",
              style: const TextStyle(color: Colors.white),
            ),

          const SizedBox(width: 10),
          Text(
            'CSEK',
            style: TextStyle(
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'user') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => const UserRequirementsPage(
                      title: 'Kullanıcı Gereksinimleri',
                    ),
              ),
            );
          }
          if (value == 'system') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => const SystemRequirementsPage(
                      title: 'Sistem Gereksinimleri',
                    ),
              ),
            );
          }
          if (value == 'donanım') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => const Subsystem1RequirementsPage(
                      title: 'Donanım Gereksinimleri',
                    ),
              ),
            );
          }
          if (value == 'yazılım') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => const Subsystem2RequirementsPage(
                      title: 'Yazılım Gereksinimleri',
                    ),
              ),
            );
          }
          if (value == 'güvenlik') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => const Subsystem3RequirementsPage(
                      title: 'Güvenlik Gereksinimleri',
                    ),
              ),
            );
          }
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
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            "Modül Seç",
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _headerButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          foregroundColor: Colors.black,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(fontSize: 14),
        ),
        child: Text(label),
      ),
    );
  }
}
