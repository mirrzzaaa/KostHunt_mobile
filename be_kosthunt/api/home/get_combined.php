<?php

require_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

$query = "
SELECT 
    p.id AS properti_id,
    p.nama_properti,
    p.alamat,
    COALESCE(p.foto, '') AS properti_foto,
    p.tipe,
    k.tipe_kelamin,
    MIN(k.harga) AS harga
FROM 
    properti p
JOIN 
    kamar k ON p.id = k.properti_id
WHERE 
    k.status = 'tersedia'
GROUP BY 
    p.id, p.nama_properti, p.alamat, p.foto, k.tipe_kelamin
ORDER BY 
    p.id DESC
";

$stmt = $db->prepare($query);

try {
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Pastikan data diformat dengan baik (misalnya: harga ke int)
    foreach ($result as &$row) {
        $row['harga'] = (int) $row['harga'];
        $row['properti_id'] = (int) $row['properti_id'];
        $row['properti_foto'] = $row['properti_foto'] ?? '';
        $row['nama_properti'] = $row['nama_properti'] ?? '';
        $row['alamat'] = $row['alamat'] ?? '';
        $row['tipe'] = $row['tipe'] ?? '';  // <== Tipe properti
        $row['tipe_kelamin'] = $row['tipe_kelamin'] ?? '';
    }

    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($result);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Terjadi kesalahan pada server: ' . $e->getMessage()]);
}

?>