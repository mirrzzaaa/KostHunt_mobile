import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();

  bool _loading = false;

  Future<void> _handleRegister() async {
    final nama = _username.text.trim();
    final email = _email.text.trim();
    final hp = _phone.text.trim();
    final pass = _pass.text;
    final confirm = _confirm.text;

    if (nama.isEmpty || email.isEmpty || hp.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Semua kolom wajib diisi')));
      return;
    }
    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alamat email tidak valid')));
      return;
    }
    if (pass != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Password dan konfirmasi password tidak sama')));
      return;
    }

    setState(() => _loading = true);
    final result = await ApiService.registerUser(
      nama: nama,
      email: email,
      password: pass,
      noHp: hp,
    );
    setState(() => _loading = false);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(result['message'])));

    if (result['success'] == true && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Column(
                children: [
                  const Text('Daftar',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF122C4F))),
                  _field(_username, 'Username'),
                  _field(_email, 'Alamat Email'),
                  _field(_phone, 'Nomor Telepon'),
                  _field(_pass, 'Kata Sandi', pass: true),
                  _field(_confirm, 'Ulangi Kata Sandi', pass: true),
                  SizedBox(
                    width: w * .7,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF122C4F),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                      ),
                      onPressed: _loading ? null : _handleRegister,
                      child: _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Daftar',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 12, fontFamily: 'Rubik'),
                children: [
                  TextSpan(
                      text: 'Dengan masuk dan mendaftar, anda menyetujui ',
                      style: TextStyle(color: Color(0xFF827C7C))),
                  TextSpan(
                      text: 'Ketentuan Layanan',
                      style: TextStyle(color: Color(0xFF122C4F))),
                  TextSpan(
                      text: ' dan ',
                      style: TextStyle(color: Color(0xFF827C7C))),
                  TextSpan(
                      text: 'Kebijakan Privasi',
                      style: TextStyle(color: Color(0xFF122C4F))),
                ],
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  /* helper text‑field */
  Widget _field(TextEditingController c, String label, {bool pass = false}) {
    final w = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: SizedBox(
        width: w * .8,
        child: TextField(
          controller: c,
          obscureText: pass,
          cursorColor: const Color(0xFF122C4F),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Color(0xFF979797)),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFF122C4F)),
                borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xFF122C4F), width: 2),
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
    );
  }
}
