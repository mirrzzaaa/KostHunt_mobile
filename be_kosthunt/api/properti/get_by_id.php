<?php
header("Content-Type: application/json");
include_once '../../config/database.php';
include_once '../../models/Properti.php';
include_once '../../helpers/response.php';

$database = new Database();
$conn = $database->getConnection();

if (!isset($_GET['id'])) {
    send_response(["message" => "Parameter id tidak ditemukan"], 400);
}

$properti = new Properti($conn);
$data = $properti->getById($_GET['id']);

if ($data) {
    send_response($data);
} else {
    send_response(["message" => "Properti tidak ditemukan"], 404);
}
?>