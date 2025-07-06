<?php
header("Content-Type: application/json");
include_once '../../config/database.php';
include_once '../../models/Pengumuman.php';
include_once '../../helpers/response.php';

if (!isset($_GET['properti_id'])) {
    send_response(["message" => "Parameter properti_id wajib disertakan"], 400);
}

$pengumuman = new Pengumuman($conn);
$data = $pengumuman->getByProperti($_GET['properti_id']);

send_response($data);
?>