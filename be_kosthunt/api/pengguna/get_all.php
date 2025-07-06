<?php
header("Content-Type: application/json");
include_once '../../config/database.php';
include_once '../../models/Pengguna.php';
include_once '../../helpers/response.php';

$pengguna = new Pengguna($conn);
$data = $pengguna->getAll();

send_response($data);
?>