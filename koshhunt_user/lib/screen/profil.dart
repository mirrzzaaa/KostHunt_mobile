import 'package:flutter/material.dart';
import '../services/session_manager.dart';
import 'home.dart';
import 'favorit.dart';
import 'chat.dart';
import 'login_screen.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({
    super.key,
  });

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  int _currentIndex = 3;
  String? _email;
  late int? _userId;

  @override
  void initState() {
    super.initState();
    SessionManager.getUserId().then((id) {
      _userId = id;
    });
  }

  Future<void> _loadEmail() async {
    final email = await SessionManager.getEmail();
    if (!mounted) return;
    setState(() => _email = email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0A2A56),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Image.asset('assets/logo.png', width: 28),
        ),
        title: const Text('Profil',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF0A2A56))),
        actions: const [Icon(Icons.notifications_none), SizedBox(width: 16)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 48,
              backgroundColor: Color(0xFFBDBDBD), // warna latar/avatar
              child: Icon(
                Icons.person, // ikon profil
                size: 48, // pas di dalam lingkaran
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text('Lalita',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0A2A56))),
            if (_email != null) ...[
              const SizedBox(height: 4),
              Text(_email!, style: const TextStyle(color: Colors.grey)),
            ],
            const SizedBox(height: 24),
            Column(
              children: [
                _menuItem(Icons.home, 'Riwayat'),
                _menuItem(Icons.wallet, 'Riwayat Transaksi'),
                _menuItem(Icons.discount, 'Voucher Diskon'),
                _menuItem(Icons.settings, 'Pengaturan'),
                _menuItem(Icons.lock, 'Kebijakan Privasi'),
                _menuItem(Icons.shield, 'Keamanan'),
                _menuItem(Icons.help_outline, 'Pusat Bantuan'),
                _menuItem(Icons.phone, 'Kost Help'),
                _menuItem(Icons.logout, 'Keluar', isLogout: true),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF122C4F),
        unselectedItemColor: Colors.grey,
        onTap: (i) {
          if (i == _currentIndex) return;
          setState(() => _currentIndex = i);
          switch (i) {
            case 0:
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const MyHomePage()));
              break;
            case 1:
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const Favorit()));
              break;
            case 2:
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const ChatPage()));
              break;
            case 3:
              break; // sudah di Profil
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.cottage), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  /* ---------- helper untuk ListTile ---------- */
  Widget _menuItem(IconData icon, String title, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : Colors.grey),
      title: Text(title,
          style: TextStyle(
              color: isLogout ? Colors.red : Colors.black,
              fontWeight: isLogout ? FontWeight.normal : FontWeight.w500)),
      onTap: () async {
        if (isLogout) {
          await SessionManager.clearSession();
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (_) => false,
          );
        }
      },
    );
  }
}
