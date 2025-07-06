<?php
header("Content-Type: application/json");
include_once '../../config/database.php';
include_once '../../models/Favorit.php';
include_once '../../helpers/response.php';

// ✅ Inisialisasi koneksi
$database = new Database();
$conn = $database->getConnection();

$data = json_decode(file_get_contents("php://input"));
$pengguna_id = $_POST['pengguna_id'] ?? null;
$properti_id = $_POST['properti_id'] ?? null;

if (!$pengguna_id || !$properti_id) {
    send_response(["message" => "pengguna_id dan properti_id wajib diisi"], 400);
}

$favorit = new Favorit($conn);

if ($favorit->create($pengguna_id, $properti_id)) {
    send_response(["message" => "Favorit berhasil ditambahkan"]);
} else {
    send_response(["message" => "Gagal menambahkan favorit"], 500);
}
