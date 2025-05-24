import 'package:flutter/material.dart';
import 'package:frontend/frontend_files/loginpage/auth_service.dart';

class CallbackPage extends StatefulWidget {
  const CallbackPage({super.key});

  @override
  State<CallbackPage> createState() => _CallbackPageState();
}

class _CallbackPageState extends State<CallbackPage> {
  @override
  void initState() {
    super.initState();
    _process();
  }

  Future<void> _process() async {
    // print('[CallbackPage] processRedirect() çağrılıyor...');
    final authService = AuthService(); // örnek oluştur
    //await authService.processRedirect(); // doğru kullanım
    final token = await authService.processRedirect();
    if (token != null) {
      //  print('[CallbackPage] Token alındı, anasayfaya yönlendiriliyor...');
      Navigator.pushReplacementNamed(context, '/');
    } else {
      //print('[CallbackPage] Token alınamadı!');
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*  SizedBox(
              height: 150,
              width: 150,
              child: Image.asset('assets/logo.png', fit: BoxFit.contain),
            ),*/
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: Colors.blueGrey),
          ],
        ),
      ),
    );
  }
}
