import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/backend/user_requirements/user_requirement_provider.dart';
import 'package:frontend/frontend_files/userReqPage/user_requirements_page.dart';
import 'package:frontend/frontend_files/system_requirements_page.dart';
import 'package:frontend/frontend_files/db_deneme_page.dart';

import 'custom_app_bar.dart';


class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRequirements = ref.watch(userRequirementListProvider);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const UserRequirementsPage(title: 'User Requirements'),
                  ),
                );
              },
              child: const Text('Kullanıcı Gereksinimleri Sayfasına Git'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const SystemRequirementsPage(title: 'System Requirements'),
                  ),
                );
              },
              child: const Text('Sistem Gereksinimleri Sayfasına Git'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DbDenemePage()),
                );
              },
              child: const Text('Veritabanı Deneme Sayfasına Git'),
            ),
          ],
        ),
      ),
    );
  }
}