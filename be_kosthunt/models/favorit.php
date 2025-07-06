<?php
class Favorit
{
    private $conn;
    private $table = "favorit";

    public function __construct($db)
    {
        $this->conn = $db;
    }

    public function create($pengguna_id, $properti_id)
    {
        $query = "INSERT INTO $this->table (pengguna_id, properti_id) VALUES (?, ?)";
        $stmt = $this->conn->prepare($query);
        return $stmt->execute([$pengguna_id, $properti_id]);
    }

    public function delete($pengguna_id, $properti_id)
    {
        $query = "DELETE FROM $this->table WHERE pengguna_id = ? AND properti_id = ?";
        $stmt = $this->conn->prepare($query);
        return $stmt->execute([$pengguna_id, $properti_id]);
    }

    public function getByUser($pengguna_id)
    {
        $query = "SELECT 
                p.id AS properti_id,
                p.nama_properti,
                p.tipe,
                p.alamat,
                p.foto AS properti_foto,
                (
                    SELECT MIN(k.harga)
                    FROM kamar k
                    WHERE k.properti_id = p.id
                ) AS harga,
                (
                    SELECT k.tipe_kelamin
                    FROM kamar k
                    WHERE k.properti_id = p.id
                    LIMIT 1
                ) AS tipe_kelamin
              FROM favorit f
              JOIN properti p ON f.properti_id = p.id
              WHERE f.pengguna_id = :pengguna_id";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':pengguna_id', $pengguna_id);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
}
?>