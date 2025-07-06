<?php
include_once __DIR__ . '/../../config/database.php';
include_once __DIR__ . '/../../models/Pembayaran.php';

header("Content-Type: application/json; charset=UTF-8");

ini_set('display_errors', 0);
error_reporting(0);

$db = (new Database())->getConnection();
$pembayaran = new Pembayaran($db);

$data = json_decode(file_get_contents("php://input"));

if (
    !empty($data->pemesanan_id) &&
    !empty($data->jumlah) &&
    !empty($data->metode)
) {
    $pembayaran->pemesanan_id = $data->pemesanan_id;
    $pembayaran->jumlah = $data->jumlah;
    $pembayaran->metode = $data->metode;
    $pembayaran->status = $data->status ?? 'menunggu';

    if ($pembayaran->create()) {
        echo json_encode(["message" => "Pembayaran berhasil disimpan"]);
    } else {
        echo json_encode(["message" => "Gagal menyimpan pembayaran", "error" => "Insert failed"]);
    }
} else {
    echo json_encode(["message" => "Data tidak lengkap"]);
}
