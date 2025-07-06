import 'package:flutter/material.dart';
import 'home.dart';
import 'favorit.dart';
import 'profil.dart';
import '../services/session_manager.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  int _currentIndex = 2;
  String searchQuery = '';
  late int? _userId;

  @override
  void initState() {
    super.initState();
    SessionManager.getUserId().then((id) {
      _userId = id;
    });
  }

  /* dummy chat list – BIARKAN */
  final List<Map<String, String>> chatList = [
    {
      'name': 'Kos Cempaka',
      'message': '✔ Apakah boleh membawa hewan?',
      'image': 'assets/kos1.png',
    },
    {
      'name': 'Kos Melati',
      'message': 'Harga sudah termasuk listrik ya?',
      'image': 'assets/kos2.png',
    },
    {
      'name': 'Kos Mawar',
      'message': 'Ada kamar kosong bulan ini?',
      'image': 'assets/kos1.png',
    },
  ];

  List<Map<String, String>> get filteredChats {
    if (searchQuery.isEmpty) return chatList;
    return chatList.where((chat) {
      final n = chat['name']!.toLowerCase();
      final m = chat['message']!.toLowerCase();
      return n.contains(searchQuery.toLowerCase()) ||
          m.contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 400;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0A2A56),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Image.asset('assets/logo.png', width: 28),
        ),
        title: const Text('Chat',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF0A2A56))),
        actions: const [Icon(Icons.notifications_none), SizedBox(width: 16)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /* search */
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Color(0xFF0A2A56)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            cursorColor: const Color(0xFF122C4F),
                            onChanged: (v) => setState(() => searchQuery = v),
                            decoration: const InputDecoration(
                              hintText: 'Cari',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.tune, color: Color(0xFF0A2A56)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            /* chat list */
            Expanded(
              child: ListView.builder(
                itemCount: filteredChats.length,
                itemBuilder: (_, i) {
                  final c = filteredChats[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            c['image']!,
                            width: isSmall ? 48 : 56,
                            height: isSmall ? 48 : 56,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c['name']!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0A2A56))),
                              const SizedBox(height: 4),
                              Text(c['message']!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      /* bottom nav – tanpa penggunaId */
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
              break; // sudah di Chat
            case 3:
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const ProfilPage()));
              break;
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
}
