import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/property_with_room.dart';

const _base = 'http://10.0.2.2/be_kosthunt/api/favorit';

Future<void> tambahFavorit(int uid, int pid) async {
  final r = await http.post(Uri.parse('$_base/create.php'), body: {
    'pengguna_id': '$uid',
    'properti_id': '$pid',
  });
  if (r.statusCode != 200) throw Exception('Gagal menambah favorit');
}

// favorit_service.dart
Future<List<int>> fetchFavorites(int uid) async {
  final r =
      await http.get(Uri.parse('$_base/get_by_user.php?pengguna_id=$uid'));
  if (r.statusCode != 200) throw Exception('Gagal memuat favorit');

  final raw = jsonDecode(r.body);
  final list =
      (raw is Map && raw.containsKey('data')) ? raw['data'] : (raw as List);

  return (list as List)
      .map<int>((e) => int.tryParse('${e['properti_id']}') ?? 0)
      .toList();
}

Future<void> hapusFavorit(int uid, int pid) async {
  final r = await http.post(Uri.parse('$_base/delete.php'), body: {
    'pengguna_id': '$uid',
    'properti_id': '$pid',
  });
  if (r.statusCode != 200) throw Exception('Gagal menghapus favorit');
}
