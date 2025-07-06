<?php
header("Content-Type: application/json");
include_once '../../config/database.php';
include_once '../../models/Fasilitas.php';
include_once '../../helpers/response.php';

if (!isset($_GET['properti_id'])) {
    send_response(["message" => "Parameter properti_id wajib disertakan"], 400);
}

$fasilitas = new Fasilitas($conn);
$data = $fasilitas->getByProperti($_GET['properti_id']);

send_response($data);
?>