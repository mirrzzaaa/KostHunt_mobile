import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../model/property_with_room.dart';
import '../services/session_manager.dart';
import '../services/favorit_service.dart';
import 'detail_kost.dart';
import 'filter_screen.dart';
import 'favorit.dart';
import 'chat.dart';
import 'profil.dart';

final NumberFormat rupiahFormatter = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _search = TextEditingController();

  int _current = 0;
  int? _userId;
  List<PropertyWithRoom> _all = [];
  List<PropertyWithRoom> _filtered = [];
  Set<int> _favIds = {};

  @override
  void initState() {
    super.initState();
    _init();
    _search.addListener(_doSearch);
  }

  Future<void> _init() async {
    _userId = await SessionManager.getUserId(); // tunggu id
    await _loadFavIds(); // baru load fav
    await _loadData(); // lalu load semua properti
  }

  Future<void> _loadFavIds() async {
    if (_userId == null) return;
    final ids = await fetchFavorites(_userId!);
    setState(() => _favIds = ids.toSet());
  }

  Future<void> _loadData() async {
    final data = await PropertyWithRoom.getAll();
    if (!mounted) return;
    setState(() {
      _all = data;
      _filtered = data;
    });
  }

  void _doSearch() {
    final q = _search.text.toLowerCase();
    setState(() {
      _filtered = _all
          .where((p) =>
              p.namaProperti.toLowerCase().contains(q) ||
              p.alamat.toLowerCase().contains(q))
          .toList();
    });
  }

  void _applyFilter(Map<String, dynamic> f) {
    final min = f['minPrice'] as int?;
    final max = f['maxPrice'] as int?;
    if (min != null && max != null && min > max) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('MIN tidak boleh lebih besar dari MAX')),
      );
      return;
    }
    setState(() {
      _filtered = _all.where((p) {
        final tipeOk = f['tipe'] == null ||
            f['tipe'].toString().toLowerCase() == p.tipe.toLowerCase();
        final genderOk = f['gender'] == null || f['gender'] == p.tipeKelamin;
        final minOk = min == null || p.harga >= min;
        final maxOk = max == null || p.harga <= max;
        return tipeOk && genderOk && minOk && maxOk;
      }).toList();
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0A2A56),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Image.asset('assets/logo.png', width: 28),
        ),
        title: const Text('Beranda',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: const [Icon(Icons.notifications_none), SizedBox(width: 16)],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * .04, vertical: 12),
              child: Row(
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
                              controller: _search,
                              decoration: const InputDecoration(
                                  hintText: 'Cari', border: InputBorder.none),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => FractionallySizedBox(
                        heightFactor: .75,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                          child: FilterPage(onApplyFilter: _applyFilter),
                        ),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.tune, color: Color(0xFF0A2A56)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _filtered.isEmpty
                  ? const Center(child: Text('Tidak ada data'))
                  : GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: w * .04),
                      itemCount: _filtered.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: w < 600 ? 2 : 3,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: .75,
                      ),
                      itemBuilder: (_, i) => KostCard(
                        data: _filtered[i],
                        isFav: _favIds.contains(_filtered[i].propertiId),
                        onChanged: (val) async {
                          final uid = _userId; // ✅ ambil dari state
                          if (uid == null) return;

                          final propId = _filtered[i].propertiId;
                          if (val) {
                            await tambahFavorit(uid, propId);
                            _favIds.add(propId);
                          } else {
                            await hapusFavorit(uid, propId);
                            _favIds.remove(propId);
                          }
                          setState(() {}); // refresh icon
                        },
                      ),
                    ),
            ),
          ],
        ),
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
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const Favorit()));
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

// ───────────────── KostCard ─────────────────
class KostCard extends StatefulWidget {
  final PropertyWithRoom data;
  final bool isFav;
  final Future<void> Function(bool) onChanged;
  const KostCard({
    super.key,
    required this.data,
    required this.isFav,
    required this.onChanged,
  });

  @override
  State<KostCard> createState() => _KostCardState();
}

class _KostCardState extends State<KostCard> {
  late bool _fav;
  @override
  void initState() {
    super.initState();
    _fav = widget.isFav;
  }

  Future<void> _toggle() async {
    final newVal = !_fav;
    setState(() => _fav = newVal);
    await widget.onChanged(newVal);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailKostPage(
            propertiId: widget.data.propertiId,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    widget.data.propertiFoto.isNotEmpty
                        ? 'assets/${widget.data.propertiFoto}'
                        : 'assets/placeholder.png',
                    width: double.infinity,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: _toggle,
                      child: Icon(
                        _fav ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.data.namaProperti,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF0A2A56))),
                  const SizedBox(height: 2),
                  Text('${widget.data.tipeKelamin} • ${widget.data.tipe}',
                      style: const TextStyle(
                          fontSize: 11, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 4),
                  Text(widget.data.alamat,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11)),
                  const SizedBox(height: 6),
                  Text(
                    rupiahFormatter.format(widget.data.harga),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
