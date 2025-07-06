<?php
class Pemesanan
{
    private $conn;
    private $table = "pemesanan";

    public $id, $pengguna_id, $kamar_id, $tanggal_mulai, $tanggal_selesai, $status, $dibuat_pada;


    public function __construct($db)
    {
        $this->conn = $db;
    }

    public function create()
    {
        $query = "INSERT INTO $this->table (pengguna_id, kamar_id, tanggal_mulai, tanggal_selesai, status)
          VALUES (:pengguna_id, :kamar_id, :tanggal_mulai, :tanggal_selesai, :status)";

        $stmt = $this->conn->prepare($query);
        return $stmt->execute([
            ':pengguna_id' => $this->pengguna_id,
            ':kamar_id' => $this->kamar_id,
            ':tanggal_mulai' => $this->tanggal_mulai,
            ':tanggal_selesai' => $this->tanggal_selesai,
            ':status' => $this->status ?? 'menunggu'
        ]);
    }

    public function getByUser($pengguna_id)
    {
        $query = "SELECT 
                p.*, 
                k.nama_kamar, 
                k.harga AS harga_kamar, 
                pr.nama_properti
              FROM $this->table p
              JOIN kamar k ON p.kamar_id = k.id
              JOIN properti pr ON k.properti_id = pr.id
              WHERE p.pengguna_id = ?
              ORDER BY p.created_at DESC";

        $stmt = $this->conn->prepare($query);
        $stmt->execute([$pengguna_id]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
}
?>