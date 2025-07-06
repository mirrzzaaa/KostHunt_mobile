<?php
header("Content-Type: application/json");
include_once '../../config/database.php';
include_once '../../models/Pengumuman.php';
include_once '../../helpers/response.php';

$data = json_decode(file_get_contents("php://input"));

if (empty($data->properti_id) || empty($data->judul) || empty($data->isi)) {
    send_response(["message" => "properti_id, judul, dan isi wajib diisi"], 400);
}

$pengumuman = new Pengumuman($conn);

if ($pengumuman->create($data->properti_id, $data->judul, $data->isi)) {
    send_response(["message" => "Pengumuman berhasil dibuat"]);
} else {
    send_response(["message" => "Gagal membuat pengumuman"], 500);
}
?>