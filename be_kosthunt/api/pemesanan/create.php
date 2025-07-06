<?php
// Mengatur agar hanya JSON yang dikembalikan
header("Content-Type: application/json");

// (Opsional) Nonaktifkan tampilan error HTML, hanya untuk produksi
ini_set('display_errors', 0);
error_reporting(E_ALL);

// Include file konfigurasi dan model
include_once '../../config/database.php';
include_once '../../models/Pemesanan.php';
include_once '../../helpers/response.php';

// Inisialisasi koneksi database
$database = new Database();
$db = $database->getConnection();

// Ambil data dari body
$data = json_decode(file_get_contents("php://input"));

// Validasi input
if (
    empty($data->pengguna_id) || empty($data->kamar_id) ||
    empty($data->tanggal_mulai) || empty($data->tanggal_selesai)
) {
    send_response(["message" => "Semua field wajib diisi"], 400);
}

// Inisialisasi objek Pemesanan
$pemesanan = new Pemesanan($db);
$pemesanan->pengguna_id = $data->pengguna_id;
$pemesanan->kamar_id = $data->kamar_id;
$pemesanan->tanggal_mulai = $data->tanggal_mulai;
$pemesanan->tanggal_selesai = $data->tanggal_selesai;
$pemesanan->status = $data->status ?? 'pending'; // pastikan sesuai enum di DB

// Eksekusi dan kirim response
if ($pemesanan->create()) {
    // Ambil ID terakhir yang disisipkan
    $lastId = $db->lastInsertId();
    send_response(["message" => "Pemesanan berhasil dibuat", "id" => $lastId]);
} else {
    send_response(["message" => "Gagal membuat pemesanan"], 500);
}
?>