import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // ⏱️ Tahan logo 3 detik, lalu pindah ke Login
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      // Atau: Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Logo
            Positioned(
              left: size.width * 0.18,
              top: size.height * 0.38,
              child: SizedBox(
                width: size.width * 0.65,
                child: Image.asset('assets/logo.png', fit: BoxFit.contain),
              ),
            ),
            // Disclaimer
            Positioned(
              bottom: size.height * 0.03,
              left: size.width * 0.05,
              right: size.width * 0.05,
              child: const _DisclaimerText(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DisclaimerText extends StatelessWidget {
  const _DisclaimerText();

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.left,
      text: const TextSpan(
        style: TextStyle(fontSize: 12, fontFamily: 'Rubik'),
        children: [
          TextSpan(
            text: 'Dengan masuk dan mendaftar, anda menyetujui ',
            style: TextStyle(color: Color(0xFF827C7C)),
          ),
          TextSpan(
            text: 'Ketentuan Layanan',
            style: TextStyle(color: Color(0xFF122C4F)),
          ),
          TextSpan(
            text: ' dan ',
            style: TextStyle(color: Color(0xFF827C7C)),
          ),
          TextSpan(
            text: 'Kebijakan Privasi',
            style: TextStyle(color: Color(0xFF122C4F)),
          ),
        ],
      ),
    );
  }
}
