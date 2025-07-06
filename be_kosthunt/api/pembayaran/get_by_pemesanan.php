<?php
header("Content-Type: application/json");
include_once '../../config/database.php';
include_once '../../models/Pembayaran.php';
include_once '../../helpers/response.php';

$database = new Database();
$db = $database->getConnection();

// Ambil input JSON
$input = json_decode(file_get_contents("php://input"), true);

if (!$input) {
    send_response(["message" => "Invalid JSON body"], 400);
    exit;
}

if (!isset($input['pemesanan_id'], $input['jumlah'], $input['metode'], $input['status'])) {
    send_response(["message" => "Semua field wajib diisi"], 400);
    exit;
}

// Assign ke variabel
$pembayaran = new Pembayaran($db);
$pembayaran->pemesanan_id = $input['pemesanan_id'];
$pembayaran->jumlah = $input['jumlah'];
$pembayaran->metode = $input['metode'];
$pembayaran->status = $input['status'];
$pembayaran->created_at = date("Y-m-d H:i:s");

// Simpan ke database
if ($pembayaran->create()) {
    send_response(["message" => "Pembayaran berhasil dibuat"], 200);
} else {
    send_response(["message" => "Gagal membuat pembayaran"], 500);
}
