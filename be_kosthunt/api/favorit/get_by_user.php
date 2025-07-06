<?php
header("Content-Type: application/json");
include_once '../../config/database.php';
include_once '../../models/Favorit.php';
include_once '../../helpers/response.php';

// ⏱️ Mulai timer untuk debugging
$start = microtime(true);

// ✅ Inisialisasi koneksi database
$database = new Database();
$conn = $database->getConnection();

// ✅ Validasi parameter pengguna_id
if (!isset($_GET['pengguna_id'])) {
    send_response(["message" => "Parameter pengguna_id wajib disertakan"], 400);
}

$pengguna_id = $_GET['pengguna_id'];

// ✅ Panggil model Favorit
$favorit = new Favorit($conn);
$data = $favorit->getByUser($pengguna_id);

// ✅ Kirim respons sukses
send_response([
    "status" => "success",
    "data" => $data
]);

// ⏱️ Catat durasi (TAPI HARUS SEBELUM send_response!)
$end = microtime(true);
$duration = $end - $start;
file_put_contents("debug.log", "get_by_user.php time: " . $duration . "s\n", FILE_APPEND);
?>