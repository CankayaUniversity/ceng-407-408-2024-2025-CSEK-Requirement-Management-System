import 'package:flutter/material.dart';
import 'package:frontend/frontend_files/loginpage/auth_service.dart';
import 'dart:html';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    // Sayfa yüklendiğinde redirect sonucu token'ı kontrol et
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleRedirect();
    });
  }

  Future<void> _handleRedirect() async {
  //  print('[LoginPage] processRedirect çalıştırılıyor...');
    final token = await AuthService().processRedirect();
    if (token != null) {
      //print('[LoginPage] Giriş başarılı, token alındı: $token');
      window.localStorage.remove('auth_state'); // state temizliği
      Navigator.pushReplacementNamed(context, '/'); // anasayfaya yönlendir
    } else {
      print('[LoginPage] Token alınamadı, giriş başarısız.');
    }
  }

  void _handleLogin(BuildContext context) async {
    try {
      print('[LoginPage] loginWithKeycloak çağrılıyor...');
      await AuthService.loginWithKeycloak();
    } catch (e) {
      print('[LoginPage] Giriş sırasında hata: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Giriş sırasında hata: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giriş Sayfası')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _handleLogin(context),
          child: const Text('Keycloak ile Giriş Yap'),
        ),
      ),
    );
  }
}