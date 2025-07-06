<?php
header("Content-Type: application/json");

include_once '../../config/database.php';
include_once '../../models/Properti.php';
include_once '../../models/Fasilitas.php';
include_once '../../models/Kamar.php';
include_once '../../helpers/response.php';

$start = microtime(true);
$database = new Database();
$conn = $database->getConnection();

// Validasi parameter
if (!isset($_GET['id'])) {
    send_response(["message" => "Parameter id tidak ditemukan"], 400);
    exit; // penting
}

$id = $_GET['id'];

// Ambil properti
$propertiModel = new Properti($conn);
$properti = $propertiModel->getById($id);

if (!$properti) {
    send_response(["message" => "Properti tidak ditemukan"], 404);
    exit;
}

// Ambil fasilitas
$fasilitasModel = new Fasilitas($conn);
$fasilitas = $fasilitasModel->getByProperti($id);

// Ambil kamar
$kamarModel = new Kamar($conn);
$kamar = $kamarModel->getByProperti($id);

// Gabungkan semua data
$response = [
    "properti" => $properti,
    "fasilitas" => $fasilitas,
    "kamar" => $kamar
];

// Logging sebelum response dikirim
$end = microtime(true);
file_put_contents("log_detail.txt", "Waktu: " . ($end - $start) . " detik\n", FILE_APPEND);

// Kirim response dan akhiri eksekusi
send_response($response);
exit;
