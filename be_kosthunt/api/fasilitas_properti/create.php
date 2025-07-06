<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json; charset=UTF-8");

include_once "../../config/database.php";

$database = new Database();
$db = $database->getConnection();

$data = json_decode(file_get_contents("php://input"));

$properti_id = $data->properti_id ?? null;
$fasilitas = $data->fasilitas ?? [];

if (!$properti_id || empty($fasilitas)) {
    echo json_encode(["message" => "Data tidak lengkap"]);
    exit;
}

try {
    $db->beginTransaction();

    foreach ($fasilitas as $fasilitas_id) {
        $stmt = $db->prepare("INSERT INTO fasilitas_properti (properti_id, fasilitas_id) VALUES (:properti_id, :fasilitas_id)");
        $stmt->execute([
            ':properti_id' => $properti_id,
            ':fasilitas_id' => $fasilitas_id
        ]);
    }

    $db->commit();
    echo json_encode(["message" => "Fasilitas properti berhasil disimpan"]);
} catch (PDOException $e) {
    $db->rollBack();
    echo json_encode(["message" => "Gagal menyimpan fasilitas", "error" => $e->getMessage()]);
}
?>