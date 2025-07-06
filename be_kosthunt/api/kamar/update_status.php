<?php
header("Content-Type: application/json");
include_once '../../config/database.php';
include_once '../../models/Kamar.php';
include_once '../../helpers/response.php';

$data = json_decode(file_get_contents("php://input"));
$database = new Database();
$conn = $database->getConnection();

if (!isset($data->id) || !isset($data->status)) {
    send_response(["message" => "ID dan status wajib disertakan"], 400);
}

$kamar = new Kamar($conn);
if ($kamar->updateStatus($data->id, $data->status)) {
    send_response(["message" => "Status kamar berhasil diperbarui"]);
} else {
    send_response(["message" => "Gagal memperbarui status kamar"], 500);
}
?>