<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json; charset=UTF-8");

include_once "../../config/database.php";
include_once "../../models/kamar.php";

$database = new Database();
$db = $database->getConnection();

$kamar = new Kamar($db); // ✅ DIBENERIN, kamu belum nulis ini barusan!

// Tangkap data dari form-data
$kamar->properti_id = $_POST['properti_id'] ?? null;
$kamar->nama_kamar = $_POST['nama_kamar'] ?? null;
$kamar->harga = $_POST['harga'] ?? null;
$kamar->tipe_kelamin = $_POST['tipe_kelamin'] ?? null; // ✅
$kamar->status = $_POST['status'] ?? null;

// Proses upload gambar
if (isset($_FILES['foto'])) {
    $targetDir = "../../uploads/kamar/";
    if (!is_dir($targetDir)) {
        mkdir($targetDir, 0777, true); // buat folder jika belum ada
    }

    $fileName = basename($_FILES["foto"]["name"]);
    $targetFile = $targetDir . $fileName;

    if (move_uploaded_file($_FILES["foto"]["tmp_name"], $targetFile)) {
        $kamar->foto = "uploads/kamar/" . $fileName; // simpan path relatif
    } else {
        $kamar->foto = null;
    }
} else {
    $kamar->foto = null;
}

// Simpan ke database
if ($kamar->create()) {
    echo json_encode(["message" => "Kamar berhasil ditambahkan"]);
} else {
    echo json_encode(["message" => "Gagal menambahkan kamar"]);
}
