<?php
class Kamar
{
    private $conn;
    private $table_name = "kamar";

    public $id;
    public $properti_id;
    public $nama_kamar;
    public $harga;
    public $tipe_kelamin;
    public $status;
    public $foto;


    public function __construct($db)
    {
        $this->conn = $db;
    }

    public function create()
    {
        $query = "INSERT INTO " . $this->table_name . " 
        (properti_id, nama_kamar, harga, tipe_kelamin, status, foto) 
        VALUES (:properti_id, :nama_kamar, :harga, :tipe_kelamin, :status, :foto)";

        $stmt = $this->conn->prepare($query);

        $stmt->bindParam(":properti_id", $this->properti_id);
        $stmt->bindParam(":nama_kamar", $this->nama_kamar);
        $stmt->bindParam(":harga", $this->harga);
        $stmt->bindParam(":tipe_kelamin", $this->tipe_kelamin);
        $stmt->bindParam(":status", $this->status);
        $stmt->bindParam(":foto", $this->foto);

        return $stmt->execute();
    }

    public function updateStatus($id, $status)
    {
        $query = "UPDATE $this->table_name SET status = :status WHERE id = :id";
        $stmt = $this->conn->prepare($query);
        return $stmt->execute([
            ':status' => $status,
            ':id' => $id
        ]);
    }

    public function getByProperti($properti_id)
    {
        $query = "SELECT id, nama_kamar, harga, tipe_kelamin, status, foto 
                  FROM $this->table_name 
                  WHERE properti_id = ?";

        $stmt = $this->conn->prepare($query);
        $stmt->execute([$properti_id]);

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getById($id)
    {
        $query = "SELECT * FROM " . $this->table . " WHERE id = ? LIMIT 1";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $id);
        $stmt->execute();

        if ($stmt->rowCount() > 0) {
            return $stmt->fetch(PDO::FETCH_ASSOC);
        }

        return null;
    }

    public function show()
    {
        $query = "SELECT * FROM kamar WHERE id = ?";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $this->id);
        $stmt->execute();
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        return $row;
    }
}
?>