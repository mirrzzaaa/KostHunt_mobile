<?php
header('Content-Type: application/json');
include_once '../../config/database.php';
include_once '../../models/Kamar.php';

$database = new Database();
$db = $database->getConnection();

$kamar = new Kamar($db);
$kamar->id = isset($_GET['id']) ? $_GET['id'] : die();

$result = $kamar->show();

if ($result) {
    echo json_encode(["data" => $result]);
} else {
    echo json_encode(["message" => "Data tidak ditemukan"]);
}
