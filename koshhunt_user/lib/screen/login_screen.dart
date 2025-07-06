import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/session_manager.dart';
import 'home.dart';
import 'register.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _LoginForm(),
    );
  }
}

/* ───────────────────────────────── FORM ───────────────────────────────── */
class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  /* ────────────── LOGIKA LOGIN ────────────── */
  Future<void> _handleLogin() async {
    final email = emailCtrl.text.trim();
    final password = passCtrl.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password wajib diisi')),
      );
      return;
    }

    final result = await ApiService.loginUser(email: email, password: password);

    if (result['success'] == true) {
      final int id = result['pengguna']['id'];
      await SessionManager.saveLoginSession(userId: id, email: email);

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MyHomePage()),
        (_) => false,
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Login gagal')),
      );
    }
  }

  /* ────────────── UI ────────────── */
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  const Text(
                    'Masuk',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF122C4F),
                    ),
                  ),
                  Image.asset('assets/login.png',
                      width: w * .5, height: w * .5),
                  const SizedBox(height: 7),

                  /* ——— FIELDS ——— */
                  _field(emailCtrl, label: 'Alamat Email'),
                  const SizedBox(height: 10),
                  _field(passCtrl, label: 'Kata Sandi', obscure: true),
                  const SizedBox(height: 15),

                  /* ——— TOMBOL LOGIN ——— */
                  SizedBox(
                    width: w * .8,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF122C4F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: _handleLogin,
                      child: const Text('Masuk',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  ),
                  const SizedBox(height: 8),

                  /* ——— LINK REGISTER ——— */
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum Punya Akun?',
                        style: TextStyle(color: Color(0xFF5B5757)),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RegisterPage()),
                        ),
                        child: const Text(
                          ' Daftar',
                          style: TextStyle(
                            color: Color(0xFF122C4F),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  /* ——— PEMBATAS & SOCIAL LOGIN ——— */
                  const SizedBox(height: 30),
                  Row(
                    children: const [
                      Expanded(child: Divider(color: Color(0xFF122C4F))),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 35),
                        child: Text('OR',
                            style: TextStyle(color: Color(0xFF122C4F))),
                      ),
                      Expanded(child: Divider(color: Color(0xFF122C4F))),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildSocialButton(
                    context,
                    'Login dengan Google',
                    'assets/google_logo.png',
                  ),
                  const SizedBox(height: 10),
                  _buildSocialButton(
                    context,
                    'Login dengan Facebook',
                    'assets/facebook_logo.png',
                  ),
                ],
              ),
            ),
          ),

          /* ——— KEBIJAKAN ——— */
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: RichText(
              textAlign: TextAlign.left,
              text: const TextSpan(
                style: TextStyle(fontSize: 12, fontFamily: 'Rubik'),
                children: [
                  TextSpan(
                    text: 'Dengan masuk dan mendaftar, Anda menyetujui ',
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
            ),
          ),
        ],
      ),
    );
  }

  /* ────────────── HELPERS ────────────── */
  Widget _field(
    TextEditingController c, {
    required String label,
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: c,
        obscureText: obscure,
        cursorColor: const Color(0xFF122C4F),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF979797)),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF122C4F)),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF122C4F), width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context,
    String text,
    String iconPath,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: screenWidth * 0.7,
        height: 49,
        decoration: BoxDecoration(
          color: const Color(0xFFFCFCFE),
          border: Border.all(color: Colors.black.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, width: 24, height: 24),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }
}
