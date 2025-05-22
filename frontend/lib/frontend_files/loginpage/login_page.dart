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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleRedirect();
    });
  }

  Future<void> _handleRedirect() async {
    final token = await AuthService().processRedirect();
    if (token != null) {
      window.localStorage.remove('auth_state');
      Navigator.pushReplacementNamed(context, '/');
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Giriş sırasında hata: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      body: Center(
        child: Card(
          color: Colors.grey[900],
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔵 Yuvarlak logo
                ClipOval(
                  child: Image.asset(
                    'assets/projectlogo.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'CSEK Gereksinim Sistemi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => _handleLogin(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '🔐 Giriş Yap',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
