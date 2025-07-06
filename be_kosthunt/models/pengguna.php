<?php
class Pengguna
{
    private $conn;
    private $table = "pengguna";
    public $id;
    public $nama;
    public $email;
    public $password;
    public $peran;
    public $no_telepon;
    public $dibuat_pada;

    public function __construct($db)
    {
        $this->conn = $db;
    }

    public function register()
    {
        $query = "INSERT INTO $this->table (nama, email, no_hp, password, peran, created_at)
              VALUES (:nama, :email, :no_hp, :password, :peran, NOW())";
        $stmt = $this->conn->prepare($query);
        return $stmt->execute([
            ':nama' => $this->nama,
            ':email' => $this->email,
            ':no_hp' => $this->no_telepon, // cocokkan dengan nama kolom
            ':password' => $this->password,
            ':peran' => $this->peran
        ]);
    }


    public function login($email)
    {
        $query = "SELECT * FROM $this->table WHERE email = :email LIMIT 1";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":email", $email);
        $stmt->execute();

        if ($stmt->rowCount() > 0) {
            return $stmt->fetch(PDO::FETCH_ASSOC);
        }

        return false;
    }


    public function getAll()
    {
        $query = "SELECT id, nama, email, no_telepon, peran, dibuat_pada FROM $this->table";
        $stmt = $this->conn->prepare($query);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getById($id)
    {
        $query = "SELECT id, nama, email, no_telepon, peran, dibuat_pada FROM $this->table WHERE id = ?";
        $stmt = $this->conn->prepare($query);
        $stmt->execute([$id]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    // Tambahan opsional untuk mengecek apakah email sudah terdaftar
    public function emailExists($email)
    {
        $query = "SELECT id FROM $this->table WHERE email = ?";
        $stmt = $this->conn->prepare($query);
        $stmt->execute([$email]);
        return $stmt->rowCount() > 0;
    }
}
?>