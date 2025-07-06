<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");

include_once '../../config/database.php';
include_once '../../models/Pengguna.php';
include_once '../../helpers/response.php';

// Ambil data dari body request JSON
$data = json_decode(file_get_contents("php://input"));

// Validasi input
if (empty($data->email) || empty($data->password)) {
    send_response(["success" => false, "message" => "Email dan password wajib diisi"], 400);
    exit;
}

// Buat koneksi
$database = new Database();
$conn = $database->getConnection();

// Buat objek pengguna dan cari data
$pengguna = new Pengguna($conn);
$row = $pengguna->login($data->email);

if ($row && password_verify($data->password, $row['password'])) {
    unset($row['password']); // Hapus password dari respons
    http_response_code(200);
    echo json_encode([
        "success" => true,
        "message" => "Login berhasil",
        "pengguna" => $row
    ]);

} else {
    send_response(["success" => false, "message" => "Login gagal, email atau password salah"], 401);
}
?>