import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/frontend_files/db_deneme_page.dart';
import 'package:frontend/frontend_files/homepage.dart';
import 'package:frontend/frontend_files/system_requirements_page.dart';
import 'package:frontend/frontend_files/userReqPage/user_requirements_page.dart';
import 'package:frontend/frontend_files/loginpage/login_page.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'frontend_files/loginpage/login_callback_page.dart';

void main() {
  //setUrlStrategy(PathUrlStrategy());
  setUrlStrategy(const HashUrlStrategy());
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Gereksinim Sistemi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => const MyHomePage(title: 'Ana Sayfa'),
        '/user': (context) => const UserRequirementsPage(title: 'Kullanıcı Gereksinimleri'),
        '/system': (context) => const SystemRequirementsPage(title: 'Sistem Gereksinimleri'),
        '/dbdeneme': (context) => const DbDenemePage(),
        '/login': (context) => const LoginPage(),
      },
        onGenerateRoute: (settings) {
          if ((settings.name ?? '').startsWith('/callback')) {
            return MaterialPageRoute(builder: (_) => const CallbackPage());
          }
          return null;
        }
    );
  }
}