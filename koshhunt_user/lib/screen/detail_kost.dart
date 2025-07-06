import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'sewa.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/widgets.dart';
import '../services/session_manager.dart';

class DetailKostPage extends StatefulWidget {
  final int propertiId;

  const DetailKostPage({super.key, required this.propertiId});

  @override
  State<DetailKostPage> createState() => _DetailKostPageState();
}

class _DetailKostPageState extends State<DetailKostPage> {
  Map<String, dynamic>? properti;
  List<dynamic> fasilitas = [];
  List<dynamic> kamar = [];
  bool isLoading = true;
  int? penggunaId;

  int? _selectedRoomId; // ⇦ id kamar terpilih
  Map<String, dynamic>? _selectedRoom; // (opsional: simpan datanya)

  @override
  void initState() {
    super.initState();
    _loadUser();
    fetchDetailData();
  }

  Future<void> _loadUser() async {
    penggunaId = await SessionManager.getUserId(); // cukup panggil helper
    setState(() {}); // trigger rebuild
  }

  Future<void> fetchDetailData() async {
    try {
      final r = await http.get(Uri.parse(
          'http://10.0.2.2/be_kosthunt/api/properti/get_detail.php?id=${widget.propertiId}'));
      final data = jsonDecode(r.body);

      setState(() {
        properti = data['properti'];
        fasilitas = data['fasilitas'] ?? [];
        kamar = data['kamar'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Gagal load detail: $e');
      setState(() => isLoading = false);
    }
  }

  String _generateStaticMapUrl(String? latitude, String? longitude) {
    const apiKey =
        'pk.dc6c7e85ee10f79d2ae3bbd6b590ac56'; // Ganti dengan token dari LocationIQ

    if (latitude == null || longitude == null) return '';

    return 'https://maps.locationiq.com/v3/staticmap'
        '?key=$apiKey'
        '&center=$latitude,$longitude'
        '&zoom=16'
        '&size=600x300'
        '&markers=icon:large-red-cutout|$latitude,$longitude';
  }

  IconData getIconData(String iconName) {
    switch (iconName) {
      case 'fa-wifi':
        return FontAwesomeIcons.wifi;
      case 'fa-snowflake':
        return FontAwesomeIcons.snowflake;
      case 'fa-video':
        return FontAwesomeIcons.video;
      case 'fa-utensils':
        return FontAwesomeIcons.utensils;
      case 'fa-shower':
        return FontAwesomeIcons.shower;
      case 'fa-warehouse':
        return FontAwesomeIcons.warehouse;
      case 'fa-book':
        return FontAwesomeIcons.book;
      case 'fa-car':
        return FontAwesomeIcons.car;
      case 'fa-motorcycle':
        return FontAwesomeIcons.motorcycle;
      case 'fa-temperature-high':
        return FontAwesomeIcons.temperatureHigh;
      default:
        return Icons.help_outline; // fallback jika tidak ditemukan
    }
  }

  @override
  Widget _buildRoomList() {
    if (kamar.isEmpty) return const Text('- Tidak ada kamar');

    return Column(
      children: kamar.map((k) {
        final bool available = k['status'] == 'tersedia';
        final bool isSelected = k['id'] == _selectedRoomId;

        String foto = (k['foto'] ?? '').toString(); // "kamar/kos5_2.png"
        final assetPath =
            foto.startsWith('kamar/') ? 'assets/$foto' : 'assets/kamar/$foto';

        return Opacity(
          // abu‑abukan yg tidak tersedia
          opacity: available ? 1 : .5,
          child: Card(
            margin: const EdgeInsets.only(bottom: 10),
            color: isSelected ? const Color(0xFFE4F1FF) : null, // highlight
            child: InkWell(
              // InkWell supaya bisa tap
              onTap: available
                  ? () => setState(() {
                        _selectedRoomId = k['id'];
                        _selectedRoom = k;
                      })
                  : null, // null = tidak bisa diklik
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    assetPath,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.bed),
                  ),
                ),
                title: Text(k['nama_kamar']),
                subtitle: Text('${k['tipe_kelamin']} • Rp ${k['harga']}'),
                trailing: Text(
                  k['status'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: available ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget build(BuildContext context) {
    if (isLoading || properti == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Kost"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              'http://10.0.2.2/be_kosthunt/uploads/${properti?['foto']}',
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.image),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    properti?['nama_properti'] ?? '',
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A2A56)),
                  ),
                  Text(
                    "${properti?['tipe']}",
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    properti?['alamat'] ?? '',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),

                  /// Lokasi Properti
                  const Divider(
                      height: 32, color: Color.fromARGB(255, 217, 217, 217)),
                  const Text(
                    "Lokasi",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        properti?['latitude'] != null &&
                                properti?['longitude'] != null
                            ? Image.network(
                                _generateStaticMapUrl(
                                  properti?['latitude'].toString(),
                                  properti?['longitude'].toString(),
                                ),
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const SizedBox(
                                    height: 180,
                                    child: Center(
                                        child: Text('Gagal memuat peta')),
                                  );
                                },
                              )
                            : const SizedBox(
                                height: 180,
                                child: Center(
                                    child: Text('Lokasi tidak tersedia')),
                              ),
                        Container(
                          width: double.infinity,
                          color: Colors.grey[100],
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            properti?['alamat'] ?? '-',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// Fasilitas
                  const Divider(),
                  const Text("Fasilitas",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  fasilitas.isEmpty
                      ? const Text("- Tidak ada fasilitas")
                      : Wrap(
                          spacing: 12,
                          children: fasilitas.map((f) {
                            return Chip(
                              label: Text(f['nama']),
                              avatar: Icon(
                                getIconData(f['ikon']),
                                color: Color(
                                    0xFF122C4F), // ganti dengan warna apa pun
                              ),
                              backgroundColor: Colors.white, // isi chip
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: Color(
                                      0xFF122C4F), // → warna border yang diinginkan
                                  width: 1.2, // → ketebalan
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                  const SizedBox(height: 8),

                  /// Kamar
                  const Divider(height: 32),
                  const Text('Kamar Tersedia',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildRoomList(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          children: [
            // tombol Chat (tetap)
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF122C4F),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Color(0xFF122C4F), width: 1.5),
                ),
                onPressed: () {/* buka chat */},
                child: const Text('Chat'),
              ),
            ),
            const SizedBox(width: 12),
            // tombol Ajukan Sewa
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF122C4F),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                // non‑aktif kalau belum pilih kamar
                onPressed: (_selectedRoomId == null)
                    ? null
                    : () {
                        if (penggunaId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Silakan login terlebih dahulu')),
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SewaPage(
                              // BUKAN AjukanSewaPage
                              propertiId: widget.propertiId,
                              kamarId:
                                  _selectedRoomId!, // akan kita validasi di bawah
                            ),
                          ),
                        );
                      },
                child: const Text('Ajukan Sewa',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
