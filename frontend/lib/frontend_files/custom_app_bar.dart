import 'package:flutter/material.dart';

import 'loginpage/auth_service.dart';
import 'package:frontend/frontend_files/userReqPage/user_requirements_page.dart';


class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
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
          _headerButton("Baseline"),
          _headerButton("Değişimler"),
          _headerButton("Dışa Aktar"),
          const Spacer(),
          if (username != null) Text("👤 $username", style: const TextStyle(color: Colors.white)),
          const SizedBox(width: 10),
          if (roles.isNotEmpty) Text("🎯 ${roles.join(', ')}", style: const TextStyle(color: Colors.white)),
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
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'user') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UserRequirementsPage(title: 'Kullanıcı Gereksinimleri'),
            ),
          );
        }
        // Diğer yönlendirmeler buraya
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'user', child: Text("Kullanıcı Gereksinimleri")),
        const PopupMenuItem(value: 'system', child: Text("Sistem Gereksinimleri")),
        const PopupMenuItem(value: 'subheading', child: Text("Alt Başlık Gereksinimleri")),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text("Modül Seç", style: TextStyle(color: Colors.black)),
      ),
    );
  }

  Widget _headerButton(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          foregroundColor: Colors.black,
          shape: const StadiumBorder(),
        ),
        child: Text(label),
      ),
    );
  }
}