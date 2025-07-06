<?php
class Properti
{
    private $conn;
    private $table = "properti";

    public $id;
    public $nama_properti;
    public $alamat;
    public $deskripsi;
    public $tipe;
    public $foto;
    public $latitude;
    public $longitude;
    public $pemilik_id;
    public $pengguna_id;
    public $created_at;

    public function __construct($db)
    {
        $this->conn = $db;


    }

    public function create()
    {
        $query = "INSERT INTO $this->table (nama_properti, alamat, deskripsi, tipe, latitude, longitude, foto, pemilik_id, created_at) VALUES (:nama_properti, :alamat, :deskripsi, :tipe, :latitude, :longitude, :foto, :pemilik_id, NOW())";


        $stmt = $this->conn->prepare($query);
        return $stmt->execute([
            ':nama_properti' => $this->nama_properti,
            ':alamat' => $this->alamat,
            ':deskripsi' => $this->deskripsi,
            ':tipe' => $this->tipe,
            ':foto' => $this->foto,
            ':latitude' => $this->latitude,
            ':longitude' => $this->longitude,
            ':pemilik_id' => $this->pemilik_id,
        ]);
    }


    public function getAll()
    {
        $query = "SELECT * FROM $this->table ORDER BY dibuat_pada DESC";
        $stmt = $this->conn->prepare($query);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getById($id)
    {
        $query = "SELECT * FROM $this->table WHERE id = ?";
        $stmt = $this->conn->prepare($query);
        $stmt->execute([$id]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    public function update($id)
    {
        $query = "UPDATE $this->table 
                  SET nama_properti = :nama_properti,
                      alamat = :alamat,
                      deskripsi = :deskripsi,
                      tipe = :tipe,
                      latitude = :latitude,
                      longitude = :longitude
                  WHERE id = :id";

        $stmt = $this->conn->prepare($query);
        return $stmt->execute([
            ':nama_properti' => $this->nama_properti,
            ':alamat' => $this->alamat,
            ':deskripsi' => $this->deskripsi,
            ':tipe' => $this->tipe,
            ':latitude' => $this->latitude,
            ':longitude' => $this->longitude,
            ':id' => $id
        ]);
    }
}
?>