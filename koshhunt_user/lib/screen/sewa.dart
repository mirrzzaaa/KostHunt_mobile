import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'pembayaran.dart';
import '../services/session_manager.dart'; // ganti kalau perlu

class SewaPage extends StatefulWidget {
  final int propertiId;
  final int kamarId;

  const SewaPage({
    Key? key,
    required this.propertiId,
    required this.kamarId,
  }) : super(key: key);

  @override
  State<SewaPage> createState() => _SewaPageState();
}

class _SewaPageState extends State<SewaPage> {
  final _tanggalController = TextEditingController();
  final _durasiController = TextEditingController();

  int? _userId;
  bool _loadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    _userId = await SessionManager.getUserId();
    setState(() => _loadingUser = false);

    if (_userId == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesi login tidak ditemukan.')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _ajukanSewa() async {
    // ── Validasi form ───────────────────────────────────────────────────────
    if (_tanggalController.text.isEmpty || _durasiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal dan durasi harus diisi.')),
      );
      return;
    }

    try {
      // ── Hitung tanggal selesai ───────────────────────────────────────────
      final startDate = DateTime.parse(_tanggalController.text);
      final durasi = int.tryParse(_durasiController.text) ?? 1;
      final endDate =
          DateTime(startDate.year, startDate.month + durasi, startDate.day);
      final tanggalSelesai = endDate.toIso8601String().split('T')[0];

      // ── Request ke backend ───────────────────────────────────────────────
      final res = await http.post(
        Uri.parse('http://10.0.2.2/be_kosthunt/api/pemesanan/create.php'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'pengguna_id': _userId,
          'kamar_id': widget.kamarId,
          'tanggal_mulai': _tanggalController.text,
          'tanggal_selesai': tanggalSelesai,
          'status': 'pending',
        }),
      );

      debugPrint('STATUS : ${res.statusCode}');
      debugPrint('BODY   : ${res.body}');

      if (res.statusCode != 200) {
        throw 'Server mengembalikan status ${res.statusCode}';
      }
      if (res.body.trim().isEmpty) {
        throw 'Server mengembalikan body kosong';
      }

      late final Map<String, dynamic> data;
      try {
        data = jsonDecode(res.body) as Map<String, dynamic>;
      } on FormatException {
        throw 'Respons bukan JSON valid: ${res.body.substring(0, 120)}…';
      }

      // ── Konversi id ke int ───────────────────────────────────────────────
      final pemesananId = int.tryParse(data['id'].toString());
      if (pemesananId == null) {
        throw data['message'] ?? 'Gagal membuat pemesanan (id null/invalid)';
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PembayaranPage(
            propertiId: widget.propertiId,
            kamarId: widget.kamarId,
            pemesananId: pemesananId, // sekarang benar‑benar int
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingUser) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Ajukan Sewa')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('Tanggal Mulai Sewa'),
            TextFormField(
              controller: _tanggalController,
              readOnly: true,
              decoration: const InputDecoration(hintText: 'yyyy-MM-dd'),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  _tanggalController.text =
                      picked.toIso8601String().split('T')[0];
                }
              },
            ),
            const SizedBox(height: 16),
            const Text('Durasi Sewa (bulan)'),
            TextFormField(
              controller: _durasiController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Contoh: 12'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _ajukanSewa,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF122C4F),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Ajukan Sewa',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tanggalController.dispose();
    _durasiController.dispose();
    super.dispose();
  }
}
