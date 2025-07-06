<?php
header("Content-Type: application/json");
include_once '../../config/database.php';
include_once '../../models/pemesanan.php';
include_once '../../helpers/response.php';

$database = new Database();
$db = $database->getConnection();

// Validasi parameter GET
if (!isset($_GET['id'])) {
    send_response(["message" => "Parameter id pengguna wajib disertakan"], 400);
}

$pemesanan = new Pemesanan($db);
$data = $pemesanan->getByUser($_GET['id']);

if ($data) {
    send_response($data);
} else {
    send_response(["message" => "Data pemesanan tidak ditemukan"], 404);
}
