<?php
header("Content-Type: application/json");
include_once '../../config/database.php';
include_once '../../models/Properti.php';
include_once '../../helpers/response.php';

$properti = new Properti($conn);
$data = $properti->getAll();

send_response($data);
?>