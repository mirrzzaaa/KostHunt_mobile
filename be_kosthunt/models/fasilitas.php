<?php
class Fasilitas
{
    private $conn;
    private $table = "fasilitas";

    public function __construct($db)
    {
        $this->conn = $db;
    }

    // Ambil semua data fasilitas (master fasilitas)
    public function getAll()
    {
        $query = "SELECT * FROM $this->table ORDER BY nama ASC"; // perbaiki dari nama_fasilitas ke nama
        $stmt = $this->conn->prepare($query);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Ambil fasilitas berdasarkan properti (relasi banyak ke banyak)
    public function getByProperti($propertiId)
    {
        $query = "SELECT f.nama, f.ikon 
              FROM fasilitas_properti fp
              JOIN fasilitas f ON fp.fasilitas_id = f.id
              WHERE fp.properti_id = :properti_id";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(':properti_id', $propertiId);
        $stmt->execute();

        $fasilitas = $stmt->fetchAll(PDO::FETCH_ASSOC);
        return $fasilitas;
    }
}
?>