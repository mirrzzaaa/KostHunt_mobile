<?php
header("Content-Type: application/json");

include_once(__DIR__ . "/../../config/database.php");
include_once(__DIR__ . "/../../models/Properti.php");
include_once(__DIR__ . "/../../helpers/response.php");

// ✅ Tambahkan koneksi ke database
$database = new Database();
$conn = $database->getConnection();

$data = (object) $_POST;

$properti = new Properti($conn);
$properti->pemilik_id = $data->pemilik_id ?? null;
$properti->nama_properti = $data->nama_properti ?? '';
$properti->alamat = $data->alamat ?? '';
$properti->deskripsi = $data->deskripsi ?? '';
$properti->tipe = $data->tipe ?? '';
$properti->latitude = $data->latitude ?? '';
$properti->longitude = $data->longitude ?? '';

// simpan file gambar
if (isset($_FILES['foto'])) {
    $foto = $_FILES['foto'];
    $target_dir = "../../uploads/";
    $target_file = $target_dir . basename($foto["name"]);
    move_uploaded_file($foto["tmp_name"], $target_file);
    $properti->foto = $foto["name"];
} else {
    $properti->foto = null;
}

if ($properti->create()) {
    send_response(["message" => "Properti berhasil ditambahkan"]);
} else {
    send_response(["message" => "Gagal menambahkan properti"], 500);
}

