import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class PembayaranPage extends StatefulWidget {
  final int propertiId;
  final int kamarId;
  final int pemesananId;

  const PembayaranPage({
    super.key,
    required this.propertiId,
    this.kamarId = 11,
    required this.pemesananId,
  });

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  int hargaKamar = 0;
  int durasi = 1;
  int biayaAdmin = 50000;
  int total = 0;
  int? penggunaId;
  String? selectedBank;

  final currencyFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _loadPenggunaId();
    fetchHargaDanDurasi();
  }

  Future<void> _loadPenggunaId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      penggunaId = prefs.getInt('pengguna_id');
    });
  }

  Future<void> fetchHargaDanDurasi() async {
    try {
      final res = await http.get(Uri.parse(
          'http://10.0.2.2/be_kosthunt/api/pemesanan/get_by_user.php?id=10'));

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        if (data.isNotEmpty) {
          final pemesanan = data.first;
          hargaKamar =
              double.tryParse(pemesanan['harga_kamar'] ?? '0')?.round() ?? 0;

          DateTime mulai = DateTime.parse(pemesanan['tanggal_mulai']);
          DateTime selesai = DateTime.parse(pemesanan['tanggal_selesai']);
          durasi = (selesai.difference(mulai).inDays / 30).round();
          if (durasi <= 0) durasi = 1;

          setState(() {
            total = (hargaKamar * durasi) + biayaAdmin;
          });
        } else {
          throw Exception("Data pemesanan kosong.");
        }
      } else {
        throw Exception("Gagal ambil data pemesanan.");
      }
    } catch (e) {
      print("ERROR fetch: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal ambil data pembayaran: $e")),
      );
    }
  }

  Future<void> bayar() async {
    if (selectedBank == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih metode pembayaran.")),
      );
      return;
    }

    if (total <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Total belum tersedia. Coba lagi.")),
      );
      return;
    }

    try {
      final res = await http.post(
        Uri.parse('http://10.0.2.2/be_kosthunt/api/pembayaran/create.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "pemesanan_id": widget.pemesananId,
          "jumlah": total,
          "metode": selectedBank,
          "status": "menunggu",
        }),
      );

      if (res.statusCode == 200) {
        try {
          final data = jsonDecode(res.body);
          if (data['message'] == 'Pembayaran berhasil disimpan') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Sewa dan pembayaran berhasil.")),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const MyHomePage()),
              (route) => false,
            );
          } else {
            throw Exception("Respon tidak sesuai");
          }
        } catch (e) {
          print("Gagal decode JSON: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Pembayaran berhasil, tapi respon rusak.")),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MyHomePage()),
            (route) => false,
          );
        }
      } else {
        print("Gagal bayar - status: ${res.statusCode}, body: ${res.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal membayar: ${res.body}")),
        );
      }
    } catch (e) {
      print("ERROR bayar: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran",
            style: TextStyle(color: Color(0xFF122C4F))),
        iconTheme: const IconThemeData(color: Color(0xFF122C4F)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Metode Pembayaran",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedBank,
            items: const [
              DropdownMenuItem(value: "BCA", child: Text("BCA")),
              DropdownMenuItem(value: "BNI", child: Text("BNI")),
              DropdownMenuItem(value: "BRI", child: Text("BRI")),
              DropdownMenuItem(value: "Mandiri", child: Text("Mandiri")),
            ],
            onChanged: (val) => setState(() => selectedBank = val),
            decoration: const InputDecoration(hintText: "Pilih Bank"),
          ),
          const SizedBox(height: 16),
          const Text("Total Tagihan",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Divider(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Harga Kamar"),
            Text(currencyFormat.format(hargaKamar)),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Durasi"),
            Text("$durasi bulan"),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Biaya Admin"),
            Text(currencyFormat.format(biayaAdmin)),
          ]),
          const Divider(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(currencyFormat.format(total),
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ]),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: bayar,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF122C4F),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text("Bayar", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
