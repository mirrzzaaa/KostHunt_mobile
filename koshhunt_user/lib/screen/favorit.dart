import 'package:flutter/material.dart';
import '../services/session_manager.dart';
import '../services/favorit_service.dart';
import '../model/property_with_room.dart';
import 'home.dart';
import 'chat.dart';
import 'profil.dart';
import 'package:intl/intl.dart';

final rupiah =
    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

class Favorit extends StatefulWidget {
  const Favorit({super.key});
  @override
  State<Favorit> createState() => _FavoritState();
}

class _FavoritState extends State<Favorit> {
  List<PropertyWithRoom> _favList = [];
  bool _loading = true;
  int _current = 1;

  @override
  void initState() {
    super.initState();
    SessionManager.getUserId().then((uid) async {
      if (uid == null) return setState(() => _loading = false);

      try {
        final ids = await fetchFavorites(uid); // ← id‑id favorit
        final all = await PropertyWithRoom.getAll(); // ← data seperti Beranda
        _favList = all.where((p) => ids.contains(p.propertiId)).toList();
      } finally {
        setState(() => _loading = false);
      }
    });
  }

  Future<void> _remove(int idx) async {
    final uid = await SessionManager.getUserId();
    if (uid == null) return;
    final pid = _favList[idx].propertiId;
    await hapusFavorit(uid, pid);
    setState(() => _favList.removeAt(idx));
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
        title: const Text('Favorit',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: const [Icon(Icons.notifications_none), SizedBox(width: 16)],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _favList.isEmpty
              ? const Center(child: Text('Belum ada properti favorit'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _favList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final k = _favList[i];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              k.propertiFoto.isNotEmpty
                                  ? 'assets/${k.propertiFoto}'
                                  : 'assets/placeholder.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(k.namaProperti,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0A2A56))),
                                    ),
                                    GestureDetector(
                                      onTap: () => _remove(i),
                                      child: const Icon(Icons.favorite,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(k.alamat,
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.grey)),
                                const SizedBox(height: 6),
                                Text(
                                  rupiah.format(k.harga),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _current,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF122C4F),
        unselectedItemColor: Colors.grey,
        onTap: (i) {
          if (i == _current) return;
          setState(() => _current = i);
          switch (i) {
            case 0:
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const MyHomePage()));
              break;
            case 1:
              break;
            case 2:
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const ChatPage()));
              break;
            case 3:
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const ProfilPage()));
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.cottage), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Pesan'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
