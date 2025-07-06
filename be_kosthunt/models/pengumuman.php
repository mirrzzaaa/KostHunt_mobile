<?php
class Pengumuman
{
    private $conn;
    private $table = "pengumuman";

    public function __construct($db)
    {
        $this->conn = $db;
    }

    public function create($properti_id, $judul, $isi)
    {
        $query = "INSERT INTO $this->table (properti_id, judul, isi, dibuat_pada)
                  VALUES (?, ?, ?, NOW())";
        $stmt = $this->conn->prepare($query);
        return $stmt->execute([$properti_id, $judul, $isi]);
    }

    public function getAll()
    {
        $query = "SELECT p.*, pr.nama_properti
                  FROM $this->table p
                  JOIN properti pr ON p.properti_id = pr.id
                  ORDER BY p.dibuat_pada DESC";
        $stmt = $this->conn->prepare($query);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getByProperti($properti_id)
    {
        $query = "SELECT * FROM $this->table WHERE properti_id = ? ORDER BY dibuat_pada DESC";
        $stmt = $this->conn->prepare($query);
        $stmt->execute([$properti_id]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
}
?>