import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/frontend_files/theme_provider.dart';

import 'package:frontend/frontend_files/homepage.dart';
import 'package:frontend/frontend_files/subSystemReqPage/sub1/subsystem1_requirements_page.dart';
import 'package:frontend/frontend_files/subSystemReqPage/sub2/subsystem2_requirements_page.dart';
import 'package:frontend/frontend_files/subSystemReqPage/sub3/subsystem3_requirements_page.dart';
import 'package:frontend/frontend_files/userReqPage/user_requirements_page.dart';
import 'package:frontend/frontend_files/loginpage/login_page.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'frontend_files/loginpage/login_callback_page.dart';
import 'frontend_files/systemReqPage/system_requirements_page.dart';

void main() {
  setUrlStrategy(const HashUrlStrategy());
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSEK Gereksinim Sistemi',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      initialRoute: '/login',
      routes: {
        '/': (context) => const MyHomePage(title: 'Ana Sayfa'),
        '/user':
            (context) =>
                const UserRequirementsPage(title: 'Kullanıcı Gereksinimleri'),
        '/system':
            (context) =>
                const SystemRequirementsPage(title: 'Sistem Gereksinimleri'),
        '/sub1':
            (context) =>
                const Subsystem1RequirementsPage(title: 'Sub1 Gereksinimleri'),
        '/sub2':
            (context) =>
                const Subsystem2RequirementsPage(title: 'Sub2 Gereksinimleri'),
        '/sub3':
            (context) =>
                const Subsystem3RequirementsPage(title: 'Sub3 Gereksinimleri'),
        '/login': (context) => const LoginPage(),
      },
      onGenerateRoute: (settings) {
        if ((settings.name ?? '').startsWith('/callback')) {
          return MaterialPageRoute(builder: (_) => const CallbackPage());
        }
        return null;
      },
    );
  }
}
