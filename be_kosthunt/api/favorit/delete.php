<?php
header("Content-Type: application/json");
include_once '../../config/database.php';
include_once '../../models/Favorit.php';
include_once '../../helpers/response.php';

$database = new Database();
$conn = $database->getConnection();

// ✅ Ambil data dari JSON body
$pengguna_id = $_POST['pengguna_id'] ?? null;
$properti_id = $_POST['properti_id'] ?? null;

if (!$pengguna_id || !$properti_id) {
    send_response(["message" => "pengguna_id dan properti_id wajib diisi"], 400);
}

$favorit = new Favorit($conn);

if ($favorit->delete($pengguna_id, $properti_id)) {
    send_response(["message" => "Favorit berhasil dihapus"]);
} else {
    send_response(["message" => "Gagal menghapus favorit"], 500);
}
