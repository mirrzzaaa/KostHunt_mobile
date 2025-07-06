<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json; charset=UTF-8");

include_once "../../config/database.php";

$database = new Database();
$db = $database->getConnection();

$data = json_decode(file_get_contents("php://input"));

if (!empty($data->nama) && !empty($data->ikon)) {
    $query = "INSERT INTO fasilitas (nama, ikon) VALUES (:nama, :ikon)";
    $stmt = $db->prepare($query);

    $stmt->bindParam(":nama", $data->nama);
    $stmt->bindParam(":ikon", $data->ikon);

    if ($stmt->execute()) {
        echo json_encode(["message" => "Fasilitas berhasil ditambahkan"]);
    } else {
        echo json_encode(["message" => "Gagal menambahkan fasilitas"]);
    }
} else {
    echo json_encode(["message" => "Data tidak lengkap"]);
}
?>