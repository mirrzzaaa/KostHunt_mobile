import 'dart:convert';
import 'package:http/http.dart' as http;

class PropertyWithRoom {
  final int propertiId;
  final String namaProperti;
  final String tipe;
  final String tipeKelamin;
  final String alamat;
  final String propertiFoto;
  final int harga;

  PropertyWithRoom({
    required this.propertiId,
    required this.namaProperti,
    required this.tipe,
    required this.tipeKelamin,
    required this.alamat,
    required this.propertiFoto,
    required this.harga,
  });

  factory PropertyWithRoom.fromJson(Map<String, dynamic> j) {
    int _int(dynamic v) => int.tryParse(v.toString().split('.').first) ?? 0;

    return PropertyWithRoom(
      propertiId: _int(j['properti_id']),
      namaProperti: j['nama_properti'] ?? '',
      tipe: j['tipe'] ?? '',
      tipeKelamin: j['tipe_kelamin'] ?? '',
      alamat: j['alamat'] ?? '',
      propertiFoto: j['properti_foto'] ?? j['foto'] ?? '',
      harga: _int(j['harga']),
    );
  }

  static Future<List<PropertyWithRoom>> getAll() async {
    final url =
        Uri.parse('http://10.0.2.2/be_kosthunt/api/home/get_combined.php');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          return data.map((json) => PropertyWithRoom.fromJson(json)).toList();
        } else {
          throw Exception("Format JSON tidak sesuai (expected List)");
        }
      } else {
        throw Exception("Gagal mengambil data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error saat fetch properti: $e");
      return [];
    }
  }
}
