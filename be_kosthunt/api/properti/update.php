<?php
header("Content-Type: application/json");
include_once '../../config/database.php';
include_once '../../models/Properti.php';
include_once '../../helpers/response.php';

$database = new Database();
$conn = $database->getConnection();

$data = json_decode(file_get_contents("php://input"));

if (!isset($data->id)) {
    send_response(["message" => "ID properti wajib disertakan"], 400);
}

$properti = new Properti($conn);
$properti->nama_properti = $data->nama_properti;
$properti->alamat = $data->alamat;
$properti->deskripsi = $data->deskripsi;
$properti->tipe = $data->tipe;
$properti->latitude = $data->latitude;
$properti->longitude = $data->longitude;

if ($properti->update($data->id)) {
    send_response(["message" => "Properti berhasil diperbarui"]);
} else {
    send_response(["message" => "Gagal memperbarui properti"], 500);
}
?>