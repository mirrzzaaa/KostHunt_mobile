<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

include_once(__DIR__ . "/../../helpers/response.php");
include_once(__DIR__ . "/../../config/database.php");
include_once(__DIR__ . "/../../models/Pengguna.php");

$data = json_decode(file_get_contents("php://input"));

// Validasi sederhana input
if (!$data || empty($data->nama) || empty($data->email) || empty($data->password) || empty($data->no_hp)) {
    send_response(["message" => "Semua field wajib diisi (nama, email, password, no_hp)"], 400);
    exit;
}

// ✅ Tambahkan koneksi database
$database = new Database();
$conn = $database->getConnection();

// ✅ Buat objek Pengguna setelah koneksi dibuat
$pengguna = new Pengguna($conn);
$pengguna->nama = $data->nama;
$pengguna->email = $data->email;
$pengguna->password = password_hash($data->password, PASSWORD_BCRYPT);
$pengguna->peran = $data->peran ?? 'pencari';
$pengguna->no_telepon = $data->no_hp ?? '';

if ($pengguna->register()) {
    send_response(["success" => true, "message" => "Registrasi berhasil"]);
} else {
    send_response(["success" => false, "message" => "Registrasi gagal"], 400);
}
