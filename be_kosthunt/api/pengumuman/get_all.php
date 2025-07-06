<?php
header("Content-Type: application/json");
include_once '../../config/database.php';
include_once '../../models/Pengumuman.php';
include_once '../../helpers/response.php';

$pengumuman = new Pengumuman($conn);
$data = $pengumuman->getAll();

send_response($data);
?>