<?php
header("Content-Type: application/json");
include_once '../../config/database.php';
include_once '../../models/Kamar.php';
include_once '../../helpers/response.php';

$database = new Database();
$conn = $database->getConnection();

if (!isset($_GET['properti_id'])) {
    send_response(["message" => "Parameter properti_id wajib disertakan"], 400);
}

$kamar = new Kamar($conn);
$data = $kamar->getByProperti($_GET['properti_id']);

send_response($data);
?>