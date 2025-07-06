<?php
header("Content-Type: application/json");
include_once '../../config/database.php';
include_once '../../models/Pengguna.php';
include_once '../../helpers/response.php';

$database = new Database();
$conn = $database->getConnection();

if (!isset($_GET['id'])) {
    send_response(["message" => "Parameter id tidak ditemukan"], 400);
}

$pengguna = new Pengguna($conn);
$data = $pengguna->getById($_GET['id']);

if ($data) {
    send_response($data);
} else {
    send_response(["message" => "Pengguna tidak ditemukan"], 404);
}
?>