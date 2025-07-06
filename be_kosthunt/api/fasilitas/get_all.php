<?php
header("Content-Type: application/json");
include_once '../../config/database.php';
include_once '../../models/Fasilitas.php';
include_once '../../helpers/response.php';

$database = new Database();
$conn = $database->getConnection();

$fasilitas = new Fasilitas($conn);
$data = $fasilitas->getAll();

echo json_encode($data);

send_response($data);
?>